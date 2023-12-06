using System;
using System.Collections.Specialized;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.WebJobs.Extensions.Redis;

namespace redis_trigger
{
    public static class WriteBehind
    {
        private record Image(string Id, string Url)
        {
            public readonly string Id = Id;
            public string Url = Url;
        };

        private record Order(string Id, string CustomerId)
        {
            public readonly string Id = Id;
            public string CustomerId = CustomerId;
        };

        private record Item(string Id, string Name, int Stock, float Price, string ImageUrl)
        {
            public readonly string Id = Id;
            public string Name = Name;
            public int Stock = Stock;
            public float Price = Price;
            public string ImageUrl = ImageUrl;
        };

        private record Position(string Id, string OrderId ,string ItemId, int Quantity)
        {
            public readonly string Id = Id;
            public string OrderId = OrderId;
            public string ItemId = ItemId;
            public int Quantity = Quantity;
        }
        
        private const string ConnectionString = "redisConnectionString";
        private const string CosmosDbAddress = "cosmosConnectionString";
        private const string DbId = "lager";
        private static readonly string[] Containers = { "Orders", "Images", "Items", "Positions" };

        private static readonly CosmosClient Client = new(Environment.GetEnvironmentVariable(CosmosDbAddress), new CosmosClientOptions 
        { 
            SerializerOptions = new CosmosSerializationOptions { PropertyNamingPolicy = CosmosPropertyNamingPolicy.CamelCase },
        });
        private static Container _container;


        

        [FunctionName("KeyeventTrigger")]
        public static async Task KeyeventTrigger(
            [RedisPubSubTrigger(ConnectionString, "__keyevent@0__:hset")] string message,
            ILogger logger)
        {
            Console.WriteLine($"Message is: {message}");
            logger.LogInformation($"Log Message: {message}");
            
            // Retrieve a Redis connection string from environmental variables.
            var redisConnectionString = Environment.GetEnvironmentVariable(ConnectionString);
            if (redisConnectionString is null)
            {
                logger.LogInformation("Redis Connection String ist null. Abbruch.");
                return;
            }
            logger.LogInformation($"Verbinde mit Redis mit Connection String: {redisConnectionString}");

            // Connect to a Redis cache instance.
            var redisConnection = await ConnectionMultiplexer.ConnectAsync(redisConnectionString);

            if (!redisConnection.IsConnected)
            {
                logger.LogInformation($"Verbindung fehlgeschlagen. Abbruch.");
                return;
            }
            
            logger.LogInformation("Verbinden erfolgreich!");
            
            var cache = redisConnection.GetDatabase();
            
            // Get the key that was set and its value.
            var path = message.Split(":");
            logger.LogInformation($"Key(s) sind: {string.Join(", ", path)}");
            
            var value = cache.HashValues(message);
            logger.LogInformation($"---> Werte für diesen Key(s) sind: {string.Join(", ", value)}");

            switch (path[1])
            {
                case "item":
                    await InsertOrUpdateItem(path[2], value, logger); 
                    break;
                case "image": await InsertOrUpdateImage(path[2], value, logger);
                    break;
                default:
                    if (path.Length > 3)
                    {
                        await InsertOrUpdatePosition(path[2], path[4], value, logger);
                    }
                    else
                    {
                        await InsertOrUpdateOrder(path[2], value, logger);
                    }
                    break;
            };
        }

        private static async Task InsertOrUpdateOrder(string key, RedisValue[] value, ILogger logger)
        {
            _container = Client.GetDatabase(DbId).GetContainer(Containers[0]);
            var customerId = value[0].ToString();
            var order = new Order(key, customerId);
            
            logger.LogInformation($"Füge Bestellung hinzu oder ändere sie mit Id: {order.Id}...");
            
            try
            {
                await _container.UpsertItemAsync(order, new PartitionKey(order.Id));
            }
            catch (Exception ex)
            {
                logger.LogInformation(
                    $"Fehler beim Eintragen/Ändern der Bestellung mit Id: {key}, Fehldermeldung: ${ex.Message}");
                return;
            }

            logger.LogInformation($"Bestellung erfolgreich abgespeichert/geändert!");
        }

        private static async Task InsertOrUpdateImage(string key, RedisValue[] value, ILogger logger)
        {
            _container = Client.GetDatabase(DbId).GetContainer(Containers[1]);
            var imageUrl = value[0].ToString();
            var image = new Image(key, imageUrl);
            
            logger.LogInformation($"Füge Bild hinzu oder ändere es mit Id: {image.Id}...");

            try
            {
                await _container.UpsertItemAsync(image, new PartitionKey(image.Id));
            }
            catch (Exception ex)
            {
                logger.LogInformation(
                    $"Fehler beim Eintragen/Ändern des Bildes mit dem Key: {key}, Fehldermeldung: ${ex.Message}");
                return;
            }

            logger.LogInformation($"Bild erfolgreich abgespeichert/geändert!");
        }

        private static async Task InsertOrUpdateItem(string key, RedisValue[] value, ILogger logger)
        {
            _container = Client.GetDatabase(DbId).GetContainer(Containers[2]);
            var name = value[0].ToString();
            var stock = int.Parse(value[1].ToString());
            var price = float.Parse(value[2].ToString());
            var imageUrl = value[3].ToString();
            var item = new Item(key, name, stock, price, imageUrl);
            
            logger.LogInformation($"Füge Artikel hinzu oder ändere ihn mit Id: {item.Id}...");
            
            try
            {
                await _container.UpsertItemAsync(item, new PartitionKey(item.Id));
            }
            catch (Exception ex)
            {
                logger.LogInformation(
                    $"Fehler beim Eintragen/Ändern des Items mit dem Key: {key}, Fehldermeldung: ${ex.Message}");
                return;
            }

            logger.LogInformation($"Item erfolgreich abgespeichert/geändert!");
        }
        
        private static async Task InsertOrUpdatePosition(string orderKey, string positionKey, RedisValue[] value, ILogger logger)
        {
            _container = Client.GetDatabase(DbId).GetContainer(Containers[3]);
            var itemId = value[0].ToString();
            var quantity = int.Parse(value[1].ToString());
            var position = new Position(positionKey, orderKey, itemId, quantity);
            
            logger.LogInformation($"Füge Position hinzu oder ändere sie mit Id: {positionKey} und zugehörig zu Bestellung mit Id: {orderKey}...");
            
            try
            {
                await _container.UpsertItemAsync(position, new PartitionKey(position.Id));
            }
            catch (Exception ex)
            {
                logger.LogInformation(
                    $"Fehler beim Eintragen/Ändern der Position mit dem Key: {positionKey}, Fehldermeldung: ${ex.Message}");
                return;
            }

            logger.LogInformation($"Position erfolgreich abgespeichert/geändert!");
        }
    }
}