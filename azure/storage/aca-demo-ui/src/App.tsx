
import { Button } from './components/ui/button'
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"

import { useEffect, useState } from 'react';

interface Position {
  id: number;
  quantity: number;
}

interface Item {
  id: number;
  name: string;
  price: number;
  stock: number;
  image: string | undefined;
}

interface Order {
  id: number;
  customer: string;
  items: Position[];
}

function App() {

  const [items, setItems] = useState<Item[]>([]);
  const [orders, setOrders] = useState<Order[]>([]);

  
  function fetchOrders() { 
    console.log("fetching tasks");
    fetch("https://bestellverwaltung.lennartbeneke.de/api/orders", {
      method: 'GET',
    })
    .then((response) => response.json())
    .then((data) => {setOrders(data); console.log(data)})
    .catch((error) => console.error(error));
  }
  
  function fetchItems() { 
    console.log("fetching persons");
    fetch("https://lagerverwaltung.lennartbeneke.de/api/products", {
      method: 'GET',
    })
    .then((response) => response.json())
    .then((data) => {setItems(data); console.log(data)})
    .catch((error) => console.error(error));
  }

  useEffect(() => {
    fetchOrders();
    fetchItems();
  }, []);

  return (
    <>
      <div className="bg-gray-800 flex items-center justify-center h-screen  w-screen">
        <div className="w-80% max-w-screen-lg p-8 text-2xl text-white">
          <div className='flex justify-center'>
            <Button onClick={() => {fetchItems(); fetchOrders(); console.log("Click!")}}>Refresh</Button>
          </div>
          <div>
            <Table className='mb-16'>
              <TableCaption>Lagerbestand.</TableCaption>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-[100px] font-bold pr-32">Name</TableHead>
                  <TableHead className="font-bold text-right">Preis</TableHead>
                  <TableHead className="font-bold text-right">Bestand</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((item: Item) => (
                  <TableRow key={item.id}>
                    <TableCell className="font-medium">{item.name}</TableCell>
                    <TableCell className="text-right">{item.price} €</TableCell>
                    <TableCell className="text-right">{item.stock}</TableCell>
                    <TableCell>
                      {item.image &&
                        <Dialog>
                          <DialogTrigger asChild>
                            <Button variant="outline">Foto</Button>
                          </DialogTrigger>
                          <DialogContent className="sm:max-w-[425px]">
                            <DialogHeader>
                              <DialogTitle>Foto für {item.name}</DialogTitle>
                              <DialogDescription>
                                {item.name} | {item.price} € | {item.stock} Stück
                              </DialogDescription>
                            </DialogHeader>
                            <picture>
                              <img src={`https://cloudshandson.blob.core.windows.net/bildspeicher/${item.image}?st=2023-12-01T15:50:23Z&se=2023-12-06T23:50:23Z&si=webapp&spr=https&sv=2022-11-02&sr=c&sig=oK5PxXskq26DgSnYIf4A3Dl6J7wABUNlwCp%2BIl5kk1w%3D`} alt={item.name} />
                            </picture>
                            <DialogFooter>
                              <Button type="submit">Save changes</Button>
                            </DialogFooter>
                          </DialogContent>
                        </Dialog>
                      }
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>

            <Table className=''>
              <TableCaption>Bestellungen.</TableCaption>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-[100px] font-bold">Bestellung</TableHead>
                  <TableHead className='font-bold'>Kunde</TableHead>
                  <TableHead className="text-right font-bold">Produkt</TableHead>
                  <TableHead className="text-right font-bold">Anzahl</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {orders.map((order: Order) => (
                  order.items.map((item: Position) => (
                    <TableRow key={item.id}>
                      <TableCell className="font-medium">{order.id}</TableCell>
                      <TableCell className="font-medium">{order.customer}</TableCell>
                      <TableCell className="text-right">{item.id}</TableCell>
                      <TableCell className="text-right">{item.quantity}</TableCell>
                    </TableRow>
                  ))
                ))}
              </TableBody>
            </Table>
          </div>
        </div>
      </div>
    </>
  )
}

export default App
