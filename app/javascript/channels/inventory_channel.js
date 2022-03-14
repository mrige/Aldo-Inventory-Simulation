import consumer from './consumer';

consumer.subscriptions.create('InventoryChannel', {
  connected() {
    // Called when the subscription is ready for use on the server
    this.perform('populate');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('Terminated');
  },

  received(data) {
    // Called when there's incoming data.shoe on the websocket for this channel
    let id = `high-shoe-${data.shoe.id}`;
    if (data.shoe.inventory < 100) {
      id = `low-shoe-${data.shoe.id}`;
    }
    const shoe_item = document.getElementById(id);

    if (shoe_item) {
      const shoe_inventory = shoe_item.children[2];
      let prev_inventory = shoe_inventory.innerHTML;

      console.log(
        parseInt(prev_inventory),
        prev_inventory,
        data.shoe.inventory
      );
      if (parseInt(prev_inventory) > 100) {
        if (data.shoe.inventory < 100) {
          console.log('i am');
          document.getElementById(`high-shoe-${data.shoe.id}`).remove();
          shoe_item.children[2].innerHTML = data.shoe.inventory;
          document.getElementById('low-shoe-content').appendChild(shoe_item);
        } else {
          shoe_inventory.innerHTML = data.shoe.inventory;
        }
      } else {
        if (data.shoe.inventory > 100) {
          console.log('i am not');
          document.getElementById(`low-shoe-${data.shoe.id}`).remove();
          shoe_item.children[2].innerHTML = data.shoe.inventory;
          document.getElementById('high-shoe-content').appendChild(shoe_item);
        } else {
          shoe_inventory.innerHTML = data.shoe.inventory;
        }
      }

      if (data.shoe.inventory >= 100) {
        shoe_item.style.background = 'red';
      } else if (data.shoe.inventory >= 50) {
        shoe_item.style.background = 'yellow';
      } else {
        shoe_item.style.background = 'green';
      }
    } else {
      const tr = document.createElement('tr');
      tr.setAttribute('id', id);
      let div = '';
      if (data.shoe.inventory < 100) {
        document.getElementById(`high-shoe-${data.shoe.id}`)?.remove();

        div = `
        <td>${data.store?.name} </td>
        <td> ${data.shoe.name} </td>
        <td id="inventory"> ${data.shoe.inventory} </td>
      `;

        tr.innerHTML = div;
        document.getElementById('low-shoe-content')?.appendChild(tr);
      } else {
        document.getElementById(`low-shoe-${data.shoe.id}`)?.remove();

        div = `
        <td>${data.store?.name} </td>
        <td> ${data.shoe.name} </td>
        <td id="inventory"> ${data.shoe.inventory} </td>
      `;
        div =
          data.shoe.inventory >= 100
            ? (div += `<td><a data-confirm="Are you sure?" rel="nofollow" data-method="put" href="/shoes/${data.shoe.id}/transfer">Transfer</a></td>`)
            : div;
        console.log(div);
        tr.innerHTML = div;
        document.getElementById('high-shoe-content')?.appendChild(tr);
      }

      if (data.shoe.inventory >= 100) {
        tr.style.background = 'red';
      } else if (data.shoe.inventory >= 50) {
        tr.style.background = 'yellow';
      } else {
        tr.style.background = 'green';
      }
    }
  },
});
