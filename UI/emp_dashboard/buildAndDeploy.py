import paramiko
from paramiko import SSHClient
import subprocess
import os

def correct_path(path):
    """Korrigiert den Pfad für das Zielsystem."""
    return path.replace("\\", "/")

def upload_directory(sftp, local_dir, remote_dir):
    """Rekursives Hochladen eines Verzeichnisses."""
    try:
        sftp.chdir(correct_path(remote_dir))
    except IOError:
        sftp.mkdir(correct_path(remote_dir))
        sftp.chdir(correct_path(remote_dir))

    for item in os.listdir(local_dir):
        local_path = os.path.join(local_dir, item)
        remote_path = os.path.join(remote_dir, item)
        if os.path.isfile(local_path):
            print(f"Uploading {local_path} to {correct_path(remote_path)}")
            sftp.put(local_path, correct_path(remote_path))
        elif os.path.isdir(local_path):
            upload_directory(sftp, local_path, correct_path(remote_path))

def modify_base_href(path, old, new):
    with open(path, 'r+') as file:
        content = file.read()
        content = content.replace(old, new)
        file.seek(0)
        file.write(content)
        file.truncate()

def build_and_upload_flutter_web(host, port, username, password, local_project_path, remote_project_path):
    # Modify base href before building
    index_html_path = os.path.join(local_project_path, 'web', 'index.html')
    modify_base_href(index_html_path, '<base href="$FLUTTER_BASE_HREF" />', '<base href="/meow$FLUTTER_BASE_HREF" />')

    build_command = "flutter build web"
    subprocess.run(build_command, shell=True, check=True, cwd=local_project_path)
    
    ssh = SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(host, port=port, username=username, password=password)
    
    sftp = ssh.open_sftp()
    
    local_build_path = os.path.join(local_project_path, 'build', 'web')
    upload_directory(sftp, local_build_path, remote_project_path)
    
    sftp.close()
    ssh.close()
    print("Upload completed.")

    # Revert base href after upload
    modify_base_href(index_html_path, '<base href="/meow$FLUTTER_BASE_HREF" />', '<base href="$FLUTTER_BASE_HREF" />')

host = "notonlyone.de"
port = 7534
username = "mawi"
password = "Vc81w4blGx"
local_project_path = "."
remote_project_path = "/home/mawi/servers/webserver/src/meow/"

build_and_upload_flutter_web(host, port, username, password, local_project_path, remote_project_path)