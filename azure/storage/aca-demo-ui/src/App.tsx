
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


import { useEffect, useState } from 'react';
import { Toaster } from './components/ui/toaster';
import { useToast } from './components/ui/use-toast';

interface Position {
  id: number;
  quantity: number;
}

interface Item {
  id: number;
  name: string;
  price: number;
  stock: number;
}

interface Order {
  id: number;
  customer: string;
  items: Position[];
}

function App() {

  const [items, setItems] = useState<Item[]>([]);
  const [orders, setOrders] = useState<Order[]>([]);


  const { toast } = useToast();

  function callToast(data: Response) {
    toast({
      variant: data.status === 200 ? "default" : "destructive",
      title: data.status === 200 ? "Erfolgreich" : "Fehler",
      description: data.status === 200 ? "Deine Anfrage wurde erfolgreich bearbeitet." : `Deine Anfrage wurde Abgelehnt. HTTP Code: ${data.status}.`,
      duration: 1500,
    })
  }
  
  function fetchOrders() { 
    console.log("fetching tasks");
    fetch('http://localhost:8000/api/orders', {
      method: 'GET',
    })
    .then((response) => response.json())
    .then((data) => {setOrders(data); console.log(data)})
    .catch((error) => console.error(error));
  }
  
  function fetchItems() { 
    console.log("fetching persons");
    fetch('http://localhost:9000/api/products', {
      method: 'GET',
    })
    .then((response) => response.json())
    .then((data) => setItems(data))
    .catch((error) => console.error(error));
  }


  useEffect(() => {
    fetchOrders();
    fetchItems();
  }, []);

  return (
    <>
      <div className="bg-gray-800 flex items-center justify-center h-screen  w-screen">
        <Toaster />
        <div className="w-80% max-w-screen-lg p-8 text-2xl text-white">
          <div className='flex justify-center'>
            <Button onClick={() => {fetchItems(); fetchOrders(); console.log("Click!")}}>Refresh</Button>
          </div>
          <div className=' mb-'>
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
                {items.map((item) => (
                  <TableRow key={item.id}>
                    <TableCell className="font-medium">{item.name}</TableCell>
                    <TableCell className="text-right">{item.price} €</TableCell>
                    <TableCell className="text-right">{item.stock}</TableCell>
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
