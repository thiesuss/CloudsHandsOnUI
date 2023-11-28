// connect-with-sas-token.js
import { BlobServiceClient, BlockBlobClient, BlockBlobParallelUploadOptions, ContainerClient } from '@azure/storage-blob';
import * as dotenv from 'dotenv';
dotenv.config();

const accountName = "cloudshandson";
const sasToken = "sp=racwdli&st=2023-11-28T11:19:32Z&se=2024-04-28T18:19:32Z&sv=2022-11-02&sr=c&sig=6XFvb9rIVOPP3z2h0ehKpHy1xbTPdnO76Tm1pYMT67g%3D";
if (!accountName) throw Error('Azure Storage accountName not found');
if (!sasToken) throw Error('Azure Storage accountKey not found');

// https://YOUR-RESOURCE-NAME.blob.core.windows.net?YOUR-SAS-TOKEN
const blobServiceUri = `https://${accountName}.blob.core.windows.net?${sasToken}`;

// credential not neccessary because we are using SAS
const credential = undefined;

const blobServiceClient = new BlobServiceClient(blobServiceUri, credential);

async function main() {
  const containerName = 'imageupload';
  //const blobName = 'CRTMonitor.png';

  const timestamp = Date.now();

  // create container client
  const containerClient = blobServiceClient.getContainerClient(
      containerName
  );

  // create blob client (erstmal unwichtig)
  //const blobClient = containerClient.getBlockBlobClient(blobName);
  
  // uploading File from local path
  uploadBlobFromLocalPath(containerClient, 'testimage3', 'C:/Users/thies/VSCode Projects/testimages/testimage3.png');
  //uploadBlobWithIndexTags(containerClient, 'testimage3', 'C:/Users/thies/VSCode Projects/testimages/testimage3.png')

}

async function uploadBlobFromLocalPath(
    containerClient: ContainerClient,
    blobName: string,
    localFilePath: string
  ): Promise<void> {
    // Create blob client from container client
    const blockBlobClient: BlockBlobClient = containerClient.getBlockBlobClient(blobName);
  
    await blockBlobClient.uploadFile(localFilePath);
  }

  async function uploadBlobWithIndexTags(
    containerClient: ContainerClient,
    blobName: string,
    localFilePath: string
  ): Promise<void> {
    // Specify index tags for blob
    const uploadOptions: BlockBlobParallelUploadOptions = {
      tags: {
        'Sealed': 'false',
        'Content': 'image',
        'Date': '28.11.2023',
      }
    };
  
    // Create blob client from container client
    const blockBlobClient: BlockBlobClient = containerClient.getBlockBlobClient(blobName);
  
    await blockBlobClient.uploadFile(localFilePath, uploadOptions);
  }

main()
  .then(() => console.log(`success`))
  .catch((err: unknown) => {
    if (err instanceof Error) {
      console.log(err.message);
    }
  });