import { Router } from "express";
import schemaHandler from "./middleware/schemaHandler";

// routes
import addOrder from "./routes/addOrder";
import getAllOrders from "./routes/getAllOrders";
import getOrderById from "./routes/getOrderById";

// validation schemes
import addOrderSchema from "./validation/addOrder";
import getOrderByIdSchema from "./validation/getOrderById";

const router: Router = Router();

router.post("/orders", ...schemaHandler(addOrderSchema), addOrder);
router.get("/orders", getAllOrders);
router.get("/orders/:id", ...schemaHandler(getOrderByIdSchema), getOrderById);

export default router;