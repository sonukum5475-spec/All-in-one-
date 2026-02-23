<!DOCTYPE html>
<html lang="hi">
<head>
  <link rel="icon" type="image/png" href="https://i.ibb.co/v4m0s9S/sonu-logo.png">
<link rel="apple-touch-icon" href="https://i.ibb.co/v4m0s9S/sonu-logo.png">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sonu's SuperStore - Patna</title>
    <style>
        :root { --primary: #f8cb46; --secondary: #0c831f; --bg: #f4f6f8; }
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background: var(--bg); padding-bottom: 90px; }
        
        /* Header like Blinkit/Flipkart */
        .header { background: var(--primary); padding: 15px; position: sticky; top: 0; z-index: 1000; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .header h2 { margin: 0; font-size: 20px; color: #000; }
        .delivery-time { font-size: 12px; background: white; display: inline-block; padding: 2px 8px; border-radius: 4px; margin-top: 5px; font-weight: bold; }

        /* Address Input Section */
        .user-info { background: white; margin: 10px; padding: 15px; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .user-info input, .user-info textarea { width: 100%; padding: 10px; margin: 5px 0; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; font-size: 14px; }

        /* Product Grid */
        .container { padding: 10px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .product-card { background: white; padding: 12px; border-radius: 15px; border: 1px solid #eee; transition: 0.3s; position: relative; }
        .product-card img { width: 100%; height: 120px; object-fit: contain; border-radius: 10px; margin-bottom: 8px; }
        .price-tag { font-weight: 800; font-size: 18px; color: #1a1a1a; }
        .product-name { font-size: 13px; color: #666; margin: 4px 0; height: 32px; overflow: hidden; }
        
        /* ADD Button */
        .add-btn { background: white; color: var(--secondary); border: 1px solid var(--secondary); padding: 6px 0; width: 100%; border-radius: 8px; font-weight: bold; cursor: pointer; transition: 0.2s; }
        .add-btn:hover { background: var(--secondary); color: white; }

        /* Bottom Cart Bar */
        .cart-bar { position: fixed; bottom: 0; left: 0; right: 0; background: var(--secondary); color: white; padding: 18px; display: flex; justify-content: space-between; align-items: center; z-index: 2000; border-radius: 15px 15px 0 0; box-shadow: 0 -3px 10px rgba(0,0,0,0.2); }
        .order-btn { background: white; color: var(--secondary); padding: 8px 15px; border-radius: 8px; font-weight: 900; text-transform: uppercase; border: none; }
    </style>
</head>
<body>

<div class="header">
    <h2>Sonu's SuperStore 🛒</h2>
    <div class="delivery-time">🚀 Delivery in 12 Mins (Patna)</div>
</div>

<div class="user-info">
    <input type="text" id="custName" placeholder="आपका शुभ नाम">
    <textarea id="custAddr" rows="2" placeholder="पूरा पता (जैसे: कंकड़बाग, पटना)"></textarea>
</div>

<div class="container">
    <div class="product-card">
        <img src="https://m.media-amazon.com/images/I/41-pW6L022L.jpg">
        <div class="price-tag">₹28</div>
        <div class="product-name">Sudha Gold Milk (500ml)</div>
        <button class="add-btn" onclick="addToCart('Sudha Milk', 28)">ADD</button>
    </div>

    <div class="product-card">
        <img src="https://5.imimg.com/data5/ECOM/Default/2023/9/344512403/QS/ID/AL/156475753/fresh-potato-500x500.jpg">
        <div class="price-tag">₹25</div>
        <div class="product-name">Fresh Potato / Aloo (1kg)</div>
        <button class="add-btn" onclick="addToCart('Aloo', 25)">ADD</button>
    </div>

    <div class="product-card">
        <img src="https://5.imimg.com/data5/ECOM/Default/2023/9/341991054/EM/NM/MS/156475753/fresh-onion-500x500.jpg">
        <div class="price-tag">₹40</div>
        <div class="product-name">Red Onion / Pyaaz (1kg)</div>
        <button class="add-btn" onclick="addToCart('Pyaaz', 40)">ADD</button>
    </div>

    <div class="product-card">
        <img src="https://m.media-amazon.com/images/I/81S7G2X4S6L._SL1500_.jpg">
        <div class="price-tag">₹14</div>
        <div class="product-name">Maggi Masala Noodles</div>
        <button class="add-btn" onclick="addToCart('Maggi', 14)">ADD</button>
    </div>

    <div class="product-card">
        <img src="https://5.imimg.com/data5/SELLER/Default/2023/3/SM/YI/QZ/186595701/chana-sattu-500x500.jpg">
        <div class="price-tag">₹60</div>
        <div class="product-name">Chana Sattu (500g)</div>
        <button class="add-btn" onclick="addToCart('Sattu', 60)">ADD</button>
    </div>

    <div class="product-card">
        <img src="https://m.media-amazon.com/images/I/51Y05Yp08tL._SL1000_.jpg">
        <div class="price-tag">₹45</div>
        <div class="product-name">Thums Up (750ml)</div>
        <button class="add-btn" onclick="addToCart('Thums Up', 45)">ADD</button>
    </div>
</div>

<div class="cart-bar" onclick="sendOrder()">
    <div>
        <span id="item-count">0</span> Items | 
        <span id="total-bill">₹0</span>
    </div>
    <button class="order-btn">Place Order ></button>
</div>

<script>
    let cart = [];
    let total = 0;

    function addToCart(name, price) {
        cart.push(name);
        total += price;
        document.getElementById('item-count').innerText = cart.length;
        document.getElementById('total-bill').innerText = "₹" + total;
        
        // Button Feedback
        event.target.innerText = "Added ✓";
        event.target.style.background = "#0c831f";
        event.target.style.color = "white";
        setTimeout(() => {
            event.target.innerText = "ADD";
            event.target.style.background = "white";
            event.target.style.color = "#0c831f";
        }, 1000);
    }

    function sendOrder() {
        let name = document.getElementById('custName').value;
        let addr = document.getElementById('custAddr').value;
        if(!name || !addr) { alert("कृपया अपना नाम और पता भरें!"); return; }
        if(cart.length === 0) { alert("टोकरी खाली है! कुछ सामान जोड़ें।"); return; }

        let orderList = cart.join(", ");
        let whatsappMsg = `*नया ऑर्डर - Sonu's SuperStore*\n\n👤 *ग्राहक:* ${name}\n📍 *पता:* ${addr}\n\n🛒 *सामान:* ${orderList}\n\n💰 *कुल बिल:* ₹${total}\n\n_ऑर्डर कंफर्म करने के लिए रिप्लाई करें!_`;
        
        let phoneNumber = "919135177716";
        let url = `https://wa.me/${phoneNumber}?text=${encodeURIComponent(whatsappMsg)}`;
        window.open(url, '_blank');
    }
</script>

</body>
</html>
