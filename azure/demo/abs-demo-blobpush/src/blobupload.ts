// connect-with-sas-token.js
import { BlobServiceClient, BlockBlobClient, BlockBlobParallelUploadOptions, ContainerClient } from '@azure/storage-blob';
import * as dotenv from 'dotenv';
dotenv.config();

const accountName = process.env.STORAGE_ACCOUNT_NAME;
const sasToken = process.env.SAS_TOKEN;
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
  uploadBlobFromLocalPath(containerClient, 'testimage2neu.png', 'C:/Users/thies/VSCode Projects/testimages/testimage2.png');
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
        'Content': 'image/png',
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