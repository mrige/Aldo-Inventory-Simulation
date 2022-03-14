require 'faye/websocket'
require 'eventmachine'
require 'json'

class InventoryChannel < ApplicationCable::Channel
  def subscribed
     stream_from "inventory_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def populate 
    s = []

    EM.run {
      ws = Faye::WebSocket::Client.new('ws://localhost:8080/')
    
      ws.on :message do |event|
        event_data = JSON.parse(event.data)
        store = Store.find_by name: event_data['store']
        current_shoe = Shoe.joins(:store).where(name: event_data['model'], store_id: store.id).first
        
        if current_shoe
          if current_shoe.inventory <=90
            p current_shoe
            current_shoe.update( inventory: event_data["inventory"])
            s = current_shoe
            p current_shoe
          else 
            low_quantity = Shoe.joins(:store).where('inventory < 30').order('inventory').first;
            if low_quantity
              low_quantity.update(inventory: event_data["inventory"] + low_quantity.inventory)
              s = low_quantity
            else
              current_shoe.update( inventory: event_data["inventory"])
              s = current_shoe

            end
          end
        else
          s = Shoe.create(store_id: store.id, name: event_data['model'], inventory: event_data["inventory"])

        end

        ActionCable.server.broadcast( "inventory_channel", {shoe:s, store: store})
      end
    }
  end
end
