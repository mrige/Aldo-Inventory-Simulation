# Inventory Simulation

This projects connects to an external websocket that feeds us the an Aldo store shoe inventory. This project performs a simualtion of the movement of inventory.

in the `localhost:3000` (root route) we have 2 tables the one on the left shows the low and medium quantity and the right shows the high amount of when you can transfer 30% of the inventory to the store with the lowest inventory

## Setup

```
rails db:migrate
rails db:seed
```

## Running

```
1. clone https://github.com/mathieugagne/shoe-store.git
2. follow the instruction to run the websocket server
3. cd "this project directory"
4. rails server
```
