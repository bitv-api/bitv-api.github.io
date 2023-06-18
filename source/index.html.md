--- 
title: BitV API documentation 

language_tabs: # must be one of https://git.io/vQNgJ 
  - json 

toc_footers: 
  - <a href='https://www.bitv.com/api/'> Create API Key </a> 
includes: 

search: false 

--- 


# Introduction 

## API Introduction 

Welcome to BitV API!  

This document is the only official API document of BitV, and the functions and services provided will be continuously updated here, please pay attention in time.  

You can switch APIs for different services by clicking the upper menu, and switch the document language by clicking the language button on the upper right.  

On the right side of the document are examples of request parameters and response results. 

## Update Subscription 

Information about API additions, updates, and offline information will be announced in advance to notify you. It is recommended that you pay attention to and subscribe to our announcements to obtain relevant information in a timely manner.  


## Contact us 

If you have any questions or consultations during the use of API, please refer to `Consultation Q&A` for consultation. 

# Quick Start 

## Access preparation 

If you need to use the API, please log in to the web page first, complete the API key application and permission configuration, and then develop and trade according to the details of this document.  

You can click <a href='https://www.bitv.com/api/'>here</a> to create an API Key. 

Each parent user can create 20 groups of Api Keys, and each Api Key can be set with three permissions: reading, trading, and withdrawal.  

The permission description is as follows: 

- Read permission: The read permission is used for data query interface, such as: order query, transaction query, etc. 
- Transaction authority: transaction authority is used for placing orders, canceling orders, and transferring interfaces. 
- Withdrawal permission: Withdrawal permission is used to create withdrawal orders and cancel withdrawal orders. 

Please remember the following information after successful creation: 

- `Access Key` API access key 

- `Secret Key` key used for signature authentication and encryption (visible only when applying) 

<aside class="notice"> 
Each API Key Up to 20 IP addresses (host address or network address) can be bound, and the API Key that is not bound to an IP address is valid for 90 days. For security reasons, it is strongly recommended that you bind the IP address. 
</aside> 
<aside class="warning"> 
<red><b>Risk Warning</b></red>: These two keys are closely related to account security, please do not use them at any time< b>while</b> disclosing to other people. Leakage of the API Key may cause loss of your assets (even if the withdrawal permission is not activated), if you find that the API Key is leaked, please delete the API Key as soon as possible. 
</aside>





### REST API 

REST, the abbreviation of Representational State Transfer, is currently a popular communication mechanism based on HTTP, and each URL represents a resource. 

For one-time operations such as transactions or asset withdrawals, it is recommended that developers use the REST API for operations. 

### WebSocket API 

WebSocket is a new protocol (Protocol) in HTML5. It realizes the full-duplex communication between the client and the server, and the connection between the client and the server can be established through a simple handshake, and the server can actively push information to the client according to business rules. 

It is recommended that developers use the WebSocket API to obtain information such as market conditions and trading depth. 

**Interface authentication** 

The above two interfaces include public interface and private interface. 

The public interface can be used to obtain basic information and market data. Public interfaces can be called without authentication. 

Private interfaces are available for transaction management and account management. Every private request must be signed with your API Key for verification. 

## Access URLs 


**REST API** 

**`https://api.bitv.com`**   

**Websocket Feed (market, MBP incremental market not included)** 

**`wss://api .bitv.com/ws`**   

**Websocket Feed (market, only MBP incremental market)** 

**`wss://api.bitv.com/feed`**   

**Websocket Feed (assets and orders) **

**`wss://api.bitv.com/ws/v2`*   


## Signature Authentication 

### The signature indicates that 

the API request is very likely to be tampered with during transmission over the internet. In order to ensure that the request has not been changed, except Private interfaces outside the public interface (basic information, market data) must use your API Key for signature authentication to verify whether parameters or parameter values ​​have changed during transmission.  
Each API Key needs to have appropriate permissions to access the corresponding interface, and each newly created API Key needs to be assigned permissions. Before using an interface, please check the permission type of each interface and confirm that your API Key has the corresponding permission. 

A legitimate request consists of the following parts: 

- Method request address: the access server address https://api.bitv.com 
- API access Id (AccessKeyId): the Access Key in the API Key you applied for. 
- SignatureMethod (SignatureMethod): The hash-based protocol for the user to calculate the signature, here HmacSHA256 is used. 
- SignatureVersion (SignatureVersion): The version of the signature protocol, 2 is used here. 
- Timestamp: the time (UTC time) when you made the request. Such as: 2017-05-11T16:22:06. Including this value in your query request helps prevent third parties from intercepting your request. 
- Required and optional parameters: Each method has a set of required and optional parameters that define the API call. These parameters and their meanings can be viewed in the description of each method. 
  - For GET requests, the parameters that come with each method need to be signed.
  - For POST requests, the parameters that come with each method are not subject to signature verification and need to be placed in the body.
- Signature: The value calculated by the signature, which is used to ensure that the signature is valid and has not been tampered with. 

### Signature Steps 

Specify the request to calculate the signature because when HMAC is used for signature calculation, the results obtained by using different content calculations will be completely different. Therefore, before performing signature calculation, please normalize the request. The following is an example of querying an order details request: 

when querying an order details, the complete request URL 

`https://api.bitv.com/v1/order/orders?` 

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx` 

`&SignatureMethod=HmacSHA256` 

`&SignatureVersion=2` 

`&Timestamp=2017-05-11T15:19:30` 

`&order-id=1234567890` 

**1. Request method (GET or POST, WebSocket uses GET), followed by a newline "\n"** 

For example: 
`GET\n` 

**2. Add a lowercase access domain name, followed by a newline character "\n"** 

For example: 
`api.bitv.com\n` 

**3. Access method path, followed by a newline character "\n" ** 

For example, to query orders: <BR> 
` 
/v1/order/orders\n 
`

For example WebSocket v2<BR>  
` 
/ws/v2
` 

**4. URL encode the parameters and sort them in ASCII code order** 

For example, the following is the original order of the request parameters, and after URL encoding 


`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx- 7xxxx` 

`order-id=1234567890` 

`SignatureMethod=HmacSHA256` 

`SignatureVersion=2` 

`Timestamp=2017-05-11T15%3A19%3A30` 

<aside class="notice"> 
Use UTF-8 encoding and URL Encoding, hexadecimal characters must be uppercase, such as ":" will be encoded as "%3A", and spaces will be encoded as "%20". 
</aside> 
<aside class="notice"> 
Timestamp needs to be added in YYYY-MM-DDThh:mm:ss format and URL-encoded. 
</aside>








**5. According to the above sequence, use the character "&" to connect the parameters** 


`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15%3A19%3A30&order-id=1234567890` 

** 6. The final string to be calculated for the signature is as follows** 

`GET\n` 

`api.bitv.com\n` 

`/v1/order/orders\n` 

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&SignatureMethod= HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15%3A19%3A30&order-id=1234567890` 


**7. Use the "request string" generated in the previous step and your secret key to generate a digital signature** 


1. Take the request string obtained in the previous step and the API private key as two parameters, and call the HmacSHA256 hash function to obtain the hash value. 
2. Encode the hash value with base-64, and the obtained value is used as the digital signature of this interface call. 

`4F65x5A2bLyMWVQj3Aqp+B4w+ivaA7n5Oi2SuYtCJ9o=` 

**8. Add the generated digital signature to the request** 

For the Rest interface: 

1. Add all necessary authentication parameters to the path parameters of the interface call
2. Add the digital signature to the path parameter after URL encoding, and the parameter name is "Signature". 

Ultimately, the API request sent to the server should be 

`https://api.bitv.com/v1/order/orders?AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&order-id=1234567890&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15 %3A19%3A30&Signature=4F65x5A2bLyMWVQj3Aqp%2BB4w%2BivaA7n5Oi2SuYtCJ9o%3D` 

For the WebSocket interface: 

1. Fill in the parameters and signature according to the required JSON format. 
2. The parameters in the JSON request do not need URL encoding 

For example: 

` 
{ 
    "action": "req", 
    "ch": "auth", 
    "params": { 
        "authType": "api", 
        "accessKey": "e2xxxxxx -99xxxxxx-84xxxxxx-7xxxx", 
        "signatureMethod": "HmacSHA256",
        "signature": "4F65x5A2bLyMWVQj3Aqp+B4w+ivaA7n5Oi2SuYtCJ9o=" } } 
    ` 
## 
Sub 

-user 

Sub-users can be used to isolate assets and transactions, and assets can be transferred between parent and sub-users; sub-users can only trade within sub-users, In addition, assets between sub-users cannot be transferred directly, and only the parent user has the right to transfer.  

Sub-users have independent login account passwords and API Keys, which are managed by the parent user on the web page. 

Each parent user can create 200 sub-users, and each sub-user can create 5 sets of Api Keys, and each Api Key can be set with corresponding permissions for reading and trading. 

The sub-user's API Key can also be bound to an IP address, and the validity period is the same as that of the parent user's API Key. 

Sub-users can access all public interfaces, including basic information and market conditions. The private interfaces that sub-users can access are as follows: 

| Interface| Description| 
| -------------------- ------------------------------------------- | --------- ---------------------- | 
| [POST /v1/order/orders/place](#fd6ce2a756) | Create and execute order|
| [POST /v1/order/orders/{order-id}/submitcancel](#4e53c0fccd) | Cancel an order | | [POST / 
v1/order/orders/submitCancelClientOrder](#client-order-id) | Cancel an order (based on client order ID) | 
| [POST /v1/order/orders/batchcancel](#ad00632ed5) | Batch cancel order | | 
[POST /v1/order/orders/batchCancelOpenOrders](#open-orders) | Cancel current order Order| 
| [GET /v1/order/orders/{order-id}](#92d59b6aad) | Query an order details| | [GET 
/v1/order/orders](#d72a5b49e7) | Query current order and historical order| 
| [GET /v1/order/openOrders](#95f2078356) | Query current entrusted order| 
| [GET /v1/order/matchresults](#0fa6055598) | Query transaction|
| [GET /v1/order/orders/{order-id}/matchresults](#56c6c47284) | Query transaction details of an order| | [GET /v1/account/accounts/{account-id}/balance]  
[GET /v1/account/accounts](#bd9157656f) | Query all accounts of the current user|
( #870c0ab88b) | Query the balance of the specified account| 
| [GET /v1/account/history](#84f1b5486d) | Query account history| | 
[GET /v2/account/ledger](#2f6797c498) | Query financial history| 
| [ POST /v1/account/transfer](#0d3c2e7382) | Asset Transfer | 

<aside class="notice"> 
Other interface sub-users are not accessible, if you try to access, the system will return "error-code 403". 
</aside> 


## Business Dictionary 

### Transaction pair A 

transaction pair consists of a base currency and a quote currency. Taking the trading pair BTC/USDT as an example, BTC is the base currency and USDT is the quote currency.  

The field corresponding to the base currency is base-currency.  

The corresponding field of the quotation currency is quote-currency. 

### Account
 
Different businesses require different accounts, and account-id is the unique identification ID of different business accounts.  

account-id can be obtained through the /v1/account/accounts interface, and specific accounts are distinguished according to account-type.  

Account types include:    

* spot: spot account   

### order, transaction-related ID description   

* order-id: the unique number of the order   
* client-order-id: customer-defined ID, which is passed in when placing an order, and is related to the order Corresponding to the order-id returned after success, the ID is valid within 24 hours. Allowed characters include letters (case-sensitive), numbers, underscores (_) and dashes (-), up to 64 characters 
* match-id: the order number of the order in the matchmaking   
* trade-id: the unique number of the deal   

# ## Order Type 

The current order type is composed of buying and selling directions and order operation types, for example: buy-market, buy is the buying and selling direction, and market is the operation type.    

Buying and selling direction:   

* buy: buy   
* sell: sell   

Order   type: 

* limit: limit order, this type of order needs to specify the order price and order quantity.  
* market : Market order, this type of order only needs to specify the order amount or order quantity, and does not need to specify the price. When the order enters the matchmaking, it will be directly traded with the counterparty until the amount or quantity is lower than the minimum transaction amount or transaction up to the number.  
* limit-maker: limit pending order, when the order enters the matching, it can only enter the market depth as a maker, if the order will be filled, the matching will directly reject the order.   
| -------- | -------------------- ----- | -------------------------------------------- ---- |
* ioc : immediately or cancel (immediately or cancel). After entering the matchmaking, if the order cannot be directly executed, it will be canceled directly (after part of the execution, the rest will also be cancelled).  
* stop-limit: Take profit and stop loss order, set the order higher or lower than the market price, when the order reaches the trigger price, it will officially enter the matching queue.  

### Order Status 

* submitted : Waiting for a transaction, the order in this status has entered the matching queue.  
* partial-filled : Partially filled, the order in this state is in the matching queue, and part of the order has been filled by the market, waiting for the remaining part to be filled.  
* filled : has been filled. The order in this state is not in the matching queue, and the entire quantity of the order has been traded by the market.  
* partial-canceled : partial transaction canceled. The order in this state is not in the matching queue. This state is transformed from partial-filled. Part of the order quantity has been filled, but it has been cancelled.  
* canceled : Canceled. This status order is not in the matching order, this status order does not have any transaction quantity, and has been successfully canceled.  
* canceling : canceling. The order in this state is in the process of being canceled, because the order will be canceled after being removed from the matching queue, so this state is an intermediate transition state.  

# Access Description 

## Interface overview 

| Interface classification | Category link | Overview | 
| Basic class | /v1/common/* | Basic class interface, including currency, currency pair, time stamp and other interfaces | 
| market/* | Public market interface, including transaction, depth, market, etc.| 
| Account class | /v1/account/* /v1/subuser/* | Account class interface, including Account information, sub-users, etc.| 
| Order class| /v1/order/* | Order class interface, including order placing, canceling order, order query, transaction query, 

etc. Please check the relevant interface documents according to your needs. 

## New frequency limit rules 

- At present, the new frequency limit rules are being gradually launched. Interfaces with frequency limit values ​​marked as NEW are applicable to the new frequency limit rules. 

- The new frequency limit rule adopts a UID-based frequency limit mechanism, that is, the frequency of requests from each API Key under the same UID to a single node at the same time cannot exceed the limit of the maximum number of visits allowed by the node per unit time. 

- Users can view the current rate limit usage according to "X-HB-RateLimit-Requests-Remain" (remaining frequency limit times) and "X-HB-RateLimit-Requests-Expire" (window expiration time) in the Http Header, and The expiration time of the current time window, and dynamically adjust your request frequency according to this value. 

## Frequency limit rules 

Except for interfaces that have been individually marked with a frequency limit value of NEW-<br> 

* Each API Key is limited to 10 times within 1 second<br> 
* If the interface does not require an API Key, each IP is in Limit 10 times in 1 second<br> 

For example: 

* The frequency of asset order interface calls is limited according to the API Key: 10 times in 1 second



* POST request, all parameters are sent in JSON format in the request body (body) 

## Return format 

All interfaces are in JSON format. The JSON definitions of v1 and v2 interfaces are slightly different. 

**v1 interface return format**: There are four fields at the top layer: `status`, `ch`, `ts` and `data`. The first three fields represent the request status and attributes, and the actual business data is in the `data` field. 

The following is an example of the returned format: 

```json 
{ 
  "status": "ok", 
  "ch": "market.btcusdt.kline.1day", 
  "ts": 1499223904680, 
  "data": 
// per API response data in nested JSON object } 
```
 
| parameter name | data type | description | 
| -------- | -------- | ------------ --------------------------------------------------- |
| status | string | API interface return status | 
| ch | string | The data flow corresponding to the interface data. Some interfaces do not have a corresponding data stream, so this field is not returned | 
| ts | long | The timestamp of the UTC time returned by the interface, in milliseconds | 
| data | object | The data body returned by the interface | 

**v2 interface return format**: top There are three fields: `code`, `message` and `data`. The first two fields represent the return code and error message, and the actual business data is in the `data` field. 

The following is an example of the returned format: 

```json 
{ 
  "code": 200, 
  "message": "", 
  "data": // per API response data in nested JSON object 
} 
``` 

| parameter name | data type | description | 
| -------- | -------- | ------------------ | 
| code | int | API interface return Code |
| message | string | error message (if any) | 
| data | object | data body returned by the interface | 

## data type 

This document makes the following conventions for the description of data types in JSON format: 

- `string`: string type, use Double quotes (") quotes 
- `int`: 32-bit integer, mainly related to status code, size, times, etc. 
- `long`: 64-bit integer, mainly related to Id and timestamp 
- `float`: floating point number, mainly When it comes to the amount and price, it is recommended to use high-precision floating-point type in the program 
- `object`: object, containing a sub-object {} 
- 
`array`: array, containing multiple objects 

## Best Practice 

###Security Class- 
Strong recommendation: When applying for an API Key, please bind your IP address to ensure that your API Key can only be used on your own IP. In addition, when the API Key is not bound to an IP, the validity period is 90 days , after binding the IP, it will never expire. 
- Strong recommendation: Do not expose the API Key to anyone (including third-party software or institutions), the API Key represents your account authority, and the exposure of the API Key may affect you If the API Key is leaked, please delete and recreate it as soon as possible. 

###Public Class 

**New Frequency Limit Rules** 

- The latest frequency limit rules are currently being launched gradually, and the frequency limit values ​​have been marked separately The interface applies the new frequency limit rules.

- Users can view the current frequency limit usage and location according to "X-HB-RateLimit-Requests-Remain (remaining frequency limit times)" and "X-HB-RateLimit-Requests-Expire (window expiration time)" in the Http Header The expiration time of the time window, dynamically adjust your request frequency according to this value. 

- The frequency of each API Key under the same UID at the same time requesting a single node cannot exceed the limit of the maximum number of visits allowed by the node per unit time. 

###Markets 
**Acquisition of market data** 

- For market data, it is recommended to use the WebSocket method to receive the push of data changes in real time, and to cache the data in the program. The WebSocket method has higher real-time performance and is not limited in frequency Impact. 
- It is recommended that users do not subscribe to too many topics and currency pairs in the same WebSocket connection, otherwise the network may be blocked due to the large amount of upstream data, and the connection may be disconnected. 

**Acquisition of the latest transaction price**

- It is recommended to use WebSocket to subscribe to the topic `market.$symbol.trade.detail`, which is a transaction information push, and the price of the transaction in this data is the latest transaction price, and the real-time performance is higher. 

**Acquisition of Handicap Depth** 

- If the requirement for handicap data is only buy 1 sell 1, you can use WebSocket to subscribe to `market.$symbol.bbo` topic, which will be pushed when buy 1 sell 1 changes . 
- If you need multiple files of data and do not require high real-time data, you can use WebSocket to subscribe to the `market.$symbol.depth.$type` topic, and the push cycle of this topic is 1 second.
- If you need multiple files of data and require high real-time data, you can use WebSocket to subscribe to the `market.$symbol.mbp.$levels` topic, and use this topic to send a req request to build a local depth, and Incremental updates, the fastest cycle for pushing incremental messages on this topic is 100ms. 
- It is recommended to use Rest (`/market/depth`), WebSocket full push (`market.$symbol.depth.$type`) to get the depth, and deduplicate the data according to the version field (discard the smaller version); use When WebSocket incremental push (`market.$symbol.mbp.$levels`), deduplication is performed according to the seqNum field (a smaller seqNum is discarded). 

**Acquisition of the latest transaction** 

- When subscribing to the WebSocket transaction details (`market.$symbol.trade.detail`) topic, the data can be deduplicated according to the tradeId field. 

###Order Class 
**Order Interface (/v1/order/orders/place)** 
 
- It is recommended that users place an order price according to the currency pair parameter data returned in `/v1/common/symbols` interface before placing an order , order quantity and other parameters are verified to avoid invalid order requests.
- It is recommended to carry the `client-order-id` parameter when placing an order, and the uniqueness of this parameter can be guaranteed (every time a request is sent time is different and unique), this parameter can prevent the interface from timing out or not returning due to network or other reasons when initiating an order request, in this case, the WebSocket can be pushed according to `client-order-id` Verify the incoming data, or use `/v1/order/orders/getClientOrder` interface to query the order information. 

**Search historical orders (/v1/order/orders)**

- It is recommended to use `start-time`, `end-time` parameters for querying. The input value of this parameter is a 13-digit timestamp (accurate to milliseconds). When using this parameter to query, the maximum query window is 48 hours (2 days). It is recommended to query by hour. The smaller the time range you search, the higher the accuracy of the timestamp and the higher the query efficiency. You can iteratively query based on the timestamp of the last query. 

**Notification of order status changes** 

- It is recommended to use WebSocket to subscribe to `orders.$symbol.update` topic, which has lower data latency and more accurate message order. 
- It is not recommended to use WebSocket to subscribe to the `orders.$symbol` topic. This topic has been replaced by `orders.$symbol.update`, and the service will be stopped later. Please replace it as soon as possible. 

###Account class  
**Asset Change**

- use WebSocket, subscribe to `orders.$symbol.update`, `accounts.update#${mode}` topics at the same time, `orders.$symbol.update` is used to receive status changes of orders ( Creation, transaction, cancellation, and related transaction price and quantity information), because this topic has not been cleared when pushing data, so the timeliness is faster, and the change of related assets can be received according to the `accounts.update#${mode}` topic Information, in order to maintain the funds in the account. 
- It is not recommended to subscribe to the `accounts` topic for WebSocket. This topic has been replaced by `accounts.update#${mode}`, and the service will be stopped later. Please replace it as soon as possible. 

# Frequently Asked Questions 

## API Information Notification 

Regarding API new additions, updates, and offline information, announcements will be made in advance to notify you. It is recommended that you pay attention to and subscribe to our announcements to obtain relevant information in a timely manner.  

## Access and signature related
 
### Q1: How many Api Keys can a user apply for? 

A: Each parent user can create 5 groups of Api Keys, and each Api Key can be set with three permissions: reading, trading, and withdrawal. 
Each parent user can also create 200 sub-users, and each sub-user can create 5 sets of Api Keys, and each Api Key can be set with two permissions for reading and trading.   

The following is a description of the three permissions:   

- Read permission: The read permission is used for data query interfaces, such as: order query, transaction query, etc.  
- Transaction authority: transaction authority is used for placing orders, canceling orders, and transferring interfaces.  
- Withdrawal permission: Withdrawal permission is used to create withdrawal orders and cancel withdrawal orders.  

### Q2: Why do disconnections and timeouts often occur?

A: Please check whether it belongs to the following situations: 

1. If the client server is located in mainland China, it is difficult to guarantee the stability of the connection.  

### Q3: Why is WebSocket always disconnected? 

A: The common reasons are: 

1. No reply to Pong, the WebSocket connection needs to reply Pong after receiving the Ping message sent by the server to ensure the stability of the connection. 

2. Due to network reasons, the client sent a Pong message, but the server did not receive it. 

3. The connection is disconnected due to network reasons. 

4. It is recommended that users implement a WebSocket connection disconnection and reconnection mechanism. After ensuring that the heartbeat (Ping/Pong) message is correctly replied, if the connection is accidentally disconnected, the program can automatically reconnect. 

### Q4: Why does the signature verification always fail? 

A: Please compare the difference between the string before signing with Secret Key and the following string. 

Please pay attention to the following points when comparing: 

1. The signature parameters should be sorted according to ASCII code. For example, the following are the original parameters: 
`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx` 

`order-id=1234567890` 

`SignatureMethod=HmacSHA256` 

`SignatureVersion=2`   

`Timestamp=2017-05-11T15%3A19%3A30` 

After sorting, it should be: 


`SignatureMethod=HmacSHA 256 ` 

`SignatureVersion=2` 

`Timestamp=2017-05-11T15%3A19%3A30` 

`order-id=1234567890` 

2. The signature string needs to be URL encoded. For example: 

- A colon `:` will be encoded as `%3A`, and a space will be encoded as `%20` 
- The timestamp needs to be formatted as `YYYY-MM-DDThh:mm:ss`, which is ` after URL encoding 2017-05-11T15%3A19%3A30`   

3. The signature needs to be base64 encoded 

4. The Get request parameters need to be in the signature string 

5. The time is UTC time converted to YYYY-MM-DDTHH:mm:ss 

6. Check the local time Whether there is a deviation from the standard time (the deviation should be less than 1 minute) 

7. When WebSocket sends a signature verification message, the message body does not need to be URL encoded. 

8. The Host in the signature should be the same as 

the Host in the request interface. The request Host may be changed, you can try to remove the proxy;

The network connection library you use may include the port in the host. You can try to include port 9 in the host used in the signature, 

whether there are hidden special characters in the Api Key and Secret Key, which will affect the signature 



### Q5: call interface return What is the reason for the gateway-internal-error error? 

A: Please check whether it belongs to the following situations:

1. Whether the account-id is correct or not requires the data returned by the GET /v1/account/accounts interface. 

2. It may be caused by the network, please try again later. 

3. Whether the format of the sent data is correct (standard JSON format is required). 

4. The POST request header needs to be declared as `Content-Type: application/json`. 

### Q6: What is the reason why the call interface returns a login-required error? 

A: Please check whether it belongs to the following situations: 

1. The AccessKey parameter should be brought into the URL. 
2. The Signature parameter should be brought into the URL. 
3. Whether the account-id is correct or not is the data returned by `GET /v1/account/accounts` interface. 
4. This error may be triggered when the request is made again after the frequency limit occurs. 

### Q7: What is the reason why the HTTP 405 error method-not-allowed is returned when calling the Rest interface? 

A: This error indicates that a Rest interface that does not exist has been called. Please check whether the path of the Rest interface is accurate. Due to the settings of Nginx, the request path (Path) is case-sensitive, please strictly follow the case stated in the document. 

## Market Related 

### Q1: How often is the current handicap data updated?

A: The current handicap data is updated once a second, whether it is a RESTful query or a Websocket push, it is updated once a second. If you need real-time bid, sell, and price data, you can use WebSocket to subscribe to the topic market.$symbol.bbo, which will push the latest bid, sell, and price data in real time. 

### Q2: Will the trading volume of the 24-hour market interface (/market/detail) data interface experience negative growth? 

A: The transaction volume and transaction amount in the /market/detail interface are 24-hour rolling data (the size of the translation window is 24 hours), and the cumulative transaction volume and transaction amount in the latter window may be smaller than the previous window. 

### Q3: How to get the latest transaction price? 

A: It is recommended to use the REST API `GET /market/trade` interface to request the latest transaction, or use WebSocket to subscribe to the market.$symbol.trade.detail topic, and obtain it according to the price in the returned data. 

### Q4: When is the K-line calculated? 

A: The K-line period is calculated based on Singapore time. For example, the starting period of the daily K-line is from 0:00 Singapore time to 0:00 Singapore time the next day. 

## Transaction Related 

### Q1: What is account-id? 

A: account-id corresponds to the ID of different business accounts of the user, which can be obtained through the /v1/account/accounts interface, and specific accounts are distinguished according to account-type. 

Account types include: 

- spot account   

### Q2: What is client-order-id? 

A: The client-order-id is a parameter of the order request identification, the type is a string, and the length is 64. This id is generated by the user and is valid within 24 hours.

### Q3: How to obtain the order quantity, amount, decimal limit, precision information? 

A: You can use the Rest API `GET /v1/common/symbols` to obtain relevant currency pair information. When placing an order, pay attention to the difference between the minimum order quantity and the minimum order amount.

Common errors returned are as follows:   

- order-value-min-error: The order amount is less than the minimum transaction amount   
- order-orderprice-precision-error : The price precision of the limit order is wrong   
- order-orderamount-precision-error : The order quantity precision is wrong   
- order-limitorder-price-max-error : the limit order price is higher than the limit price threshold-   
order-limitorder-price-min-error : the limit order price is lower than the limit price threshold-   
order-limitorder-amount-max-error : The limit order quantity is higher than the limit price   
threshold- order-limitorder-amount-min-error : The limit order quantity is lower than the limit price threshold   

### Q4: WebSocket order update push topic orders.\$symbol and orders.$symbol .update difference? 

A: The differences are as follows: 

1. The order.\$symbol theme is an old push theme, and the maintenance and use of the theme will stop after a period of time. It is recommended to use the order.$symbol.update theme. 

2. The new topic orders.$symbol.update has strict timing, which ensures that data is pushed strictly in the order of matching transactions, and has faster timeliness and lower delay.

3. In order to reduce the amount of repeated data push and achieve faster speed, the original order quantity and price information are not carried in the push of orders.$symbol.update. If this information is needed, it is recommended to maintain the order information locally when placing an order, or After receiving the push message, use the Rest interface to query. 

### Q5: Why is the balance insufficient when placing an order again after receiving the message that the order has been successfully filled? 

A: In order to ensure the timely delivery of orders and low latency, the result of order push is pushed directly after matching. At this time, the order may not have completed the liquidation of assets.  

It is recommended to use the following methods to ensure that funds can be placed correctly: 

1. Combined with the asset push topic `accounts` to receive asset change messages synchronously to ensure that funds have been cleared. 

2. When receiving the order push message, use the Rest interface to call the account balance to verify whether the account funds are sufficient. 

3. Keep a relatively sufficient fund balance in the account. 

### Q6: What is the difference between filled-fees and filled-points in the matching results? 

A: There are two types of transaction fees in matchmaking transactions: ordinary fees and deductible fees, and the two types will not exist at the same time. 

1. Ordinary handling fee means that the deduction is not enabled at the time of the transaction, and the original currency is used for the deduction of the handling fee. For example: when purchasing BTC under the BTCUSDT currency pair, the filled-fees field is not empty, indicating that the normal handling fee has been deducted, and the unit is BTC. 

2. The deduction of handling fee means that when the transaction is completed, the deduction is turned on, and the deduction asset is used as the deduction of the handling fee. For example, when purchasing BTC under the BTCUSDT currency pair, when the deduction assets are sufficient, filled-fees is empty, and filled-points is not empty, indicating that the deduction assets have been deducted as a handling fee. The deduction unit needs to refer to the fee-deduct-currency field 

## # Q7: What is the difference between match-id and trade-id in the matching results?

A: match-id indicates the sequence number of the order in matching, and trade-id indicates the sequence number at the time of transaction. A match-id may have multiple trade-ids (at the time of transaction), or may not have trade-id (creating order, canceling Order) 

### Q8: Why does placing an order based on the price of buying one or selling one in the current market trigger an order limit error? 

A: At present, there is a price limit protection based on the latest transaction price. For coins with poor liquidity, placing an order based on the market data may trigger the price limit protection. It is recommended to place an order based on the transaction price + handicap data information pushed by ws 

## Account deposit and withdrawal related 

### Q1: Why does the api-not-support-temp-addr error be returned when creating a withdrawal? 

A: Due to security considerations, the API only supports addresses that are already in the withdrawal address list when creating withdrawals. It does not currently support using the API to add addresses to the withdrawal address list. You need to add addresses on the web page or APP before you can use them. Withdraw operations in the API. 

### Q2: Why is the Invaild-Address error returned when USDT is withdrawn? 

A: The USDT currency is a typical one-coin multi-chain currency. When creating a withdrawal order, you should fill in the address type corresponding to the chain parameter. The following table shows the correspondence between chains and chain parameters: 

| chain | chain parameters | 
| -------------- | ---------- | 
| ERC20 (default) | usdterc20 | 
| OMNI | usdt | 
| TRX | trc20usdt | 

If the chain parameter is empty, the default chain is ERC20, or you can also assign the parameter to `usdterc20`.

If you want to withdraw coins to OMNI or TRX, the chain parameter should be filled with usdt or trc20usdt. Please refer to `GET /v2/reference/currencies` interface for available values ​​of the chain parameter. 


### Q3: How to fill in the fee field when creating a withdrawal? 

A: Please refer to the return value of the GET /v2/reference/currencies interface. The withdrawFeeType in the returned information is the type of withdrawal fee. Select the corresponding field to set the withdrawal fee according to the type. 

Withdrawal fee types include:   

- transactFeeWithdraw: single withdrawal fee (only valid for fixed type, withdrawFeeType=fixed)   
- minTransactFeeWithdraw: minimum single withdrawal fee (only valid for interval type, withdrawFeeType=circulated or ratio) 
- maxTransactFeeWithdraw : Maximum single withdrawal fee (only valid for interval type and capped ratio type, withdrawFeeType=circulated or ratio - 
transactFeeRateWithdraw : single withdrawal fee rate (only valid for ratio type, withdrawFeeType=ratio) 

# ## Q4: How do I check my withdrawal amount? 

A: Please refer to the return value of the /v2/account/withdraw/quota interface. The returned information includes the single, current, current, total withdrawal amount and remaining amount of the currency you inquired about. Quota information. 

Remarks: If you have a large withdrawal requirement and the withdrawal amount exceeds the relevant limit, you can contact the official customer service for communication.   

# Basic Information 

## Introduction

The basic information Rest interface provides public reference information such as market status, transaction pair information, currency information, currency chain information, and server timestamp. 

## Get Current Market Status 

This node returns the current latest market status. <br> 
Status enumeration values ​​include: 1 - normal (orders can be placed and canceled), 2 - pending (orders cannot be placed and canceled), 3 - orders can only be canceled (orders cannot be placed and canceled). <br> 
The suspend reason enumeration value includes: 2 - urgent maintenance, 3 - planned maintenance. <br> 

```shell 
curl "https://api.bitv.com/v2/market-status" 
``` 


### HTTP request 

- GET `/v2/market-status` 

### Request parameters 

for this interface Does not accept any arguments. 

> Responds: 

```json 
{ 
    "code": 200, 
    "message": "success", 
    "data": { 
        "marketStatus":


| code | integer | TRUE | status code | 
| message | string | FALSE | error description (if any) | 
| data | object | TRUE | | 
| { marketStatus | integer | TRUE | market status (1=normal, 2=halted , 3=cancel-only) |  
| haltStartTime | long | FALSE | market pause start time (unix time in millisecond), only valid for marketStatus=halted or cancel-only|
| haltEndTime | long | FALSE | market pause estimated end time (unix time in millisecond), only valid for marketStatus=halted or cancel-only; if marketStatus=halted or cancel-only does not return This field means that the end time of market suspension is temporarily unpredictable | 
| haltReason | integer | FALSE | reason for market suspension (2=emergency-maintenance, 3=scheduled-maintenance), only valid for marketStatus=halted or cancel-only|
| affectedSymbols } | string | FALSE | A list of trading pairs affected by market suspension, separated by commas, if all trading pairs are affected, return "all", only valid for marketStatus=halted or cancel-only | ## Get all transactions and return this 

interface

All supported trading pairs. 

```shell 
curl "https://api.bitv.com/v1/common/symbols" 
``` 


### HTTP request 

- GET `/v1/common/symbols` 

### Request parameters 

This interface does not accept any parameter. 

> Responds: 

```json 
{ 
    "status": "ok", 
        { 
            "base-currency": "btc", 
            "quote-currency": "usdt", 
            "price-precision": 2, 
            "amount-precision" : 6, 
            "symbol-partition": "main",
            "value-precision": 8,
            "min-order-amt": 0.0001,
            "max-order-amt": 1000,
            "min-order-value": 5,
            "limit-order-min-order-amt": 0.0001,
            "limit-order-max-order-amt": 1000,
            "sell-market-min-order-amt": 0.0001,
            "sell-market-max-order-amt": 100,
            "buy-market-max-order-value": 1000000,
            "leverage-ratio": 5,
            "super-margin-leverage-ratio": 3,
### return fields
            "funding-leverage-ratio": 3,
            "api-trading": "enabled" 
        }, 
    ...... 
    ] 
} 
``` 


| field name | required | data type | description | 
| --------------- ----------- | -------- | -------- | -------------------- ------------------------------------------- | 
| base-currency | true | string | The base currency in the trading pair | 
| quote-currency | true | string | The quotation currency in the trading pair | | 
price-precision | true 
| | true | integer | Counting precision of the base currency of the trading pair (digits after the decimal point) | 
symbol-partition|true|string|trading partition, possible values: [main, innovation]|| 
symbol|true| string | trading pair|
| state | true | string | trading pair status; possible values: [online, offline,suspend] online - online; offline - trading pair is offline and cannot be traded; suspend - trading is suspended; pre-online - coming online | 
| value-precision | true | integer | the precision of the transaction amount of the transaction pair (digits after the decimal point) | 
| min-order-amt | true | (to be obsolete) | 
| max-order-amt | true | float | maximum order size of a limit order for a trading pair, in base currency (to be obsolete) | | 
sell-market-min-order-amt | true | float | The minimum order size of a market sell order for a trading pair, in base currency Unit (NEW) | 
| sell-market-max-order-amt | true | float | The maximum order size of a sell order at the market price of a trading pair, in units of the base currency (NEW) | 
| limit-order-min-order-amt | true | float | The minimum order size of a limit order for a trading pair, in the unit of the base currency (NEW ) |
| limit-order-max-order-amt | true | float | The maximum order quantity of a limit order for a trading pair, in base currency (NEW) | | 
```json
| buy-market-max-order-value | true | float | The maximum order amount of a market buy order for a trading pair, in the price currency (NEW) | | min-order-value | true | float | A limit order for a trading 
pair The minimum order amount for a buy order at the market price, in the pricing currency | 
| max-order-value | false | float | The maximum order amount for a limit order and a market buy order for a trading pair, in USDT after conversion (NEW) | 
| api-trading | true | string | API trading enable flag (valid value: enabled, disabled) | 

## Get all currencies 

This interface returns all supported currencies. 


```shell 
curl "https://api.bitv.com/v1/common/currencys" 
``` 

### HTTP request 

- GET `/v1/common/currencys` 


### Request parameters 

This interface does not accept any parameter. 


> Response:

  "data": [ 
    "usdt", 
    "eth", 
    "etc" 
  ] 

### return field 


<aside class="notice">The returned "data" object is an array of strings, each string represents a supported currency. </aside> 

## APIv2 currency chain reference information 

This node is used to query the static reference information (public data) of each currency and its blockchain 

### HTTP request 

- GET `/v2/reference/currencies` 

`` `shell 
curl "https://api.bitv.com/v2/reference/currencies?currency=usdt" 
``` 

### request parameter 

| field name | required | type | field description | value range | 
| - ------------- | -------- | ------- | ---------- | -------- -------------------------------------------------- -- |
| currency | false | string | currency | btc, ltc, bch, eth, etc ... (value reference `GET /v1/common/currencys`) | | authorizedUser | false | boolean | authenticated user | true 
or false (if not filled, the default is true) | 

> Response: 

```json 
{ 
    "code":200, 
    "data":[ 
        { 
            "chains":[ 
                { 
                    "chain":"trc20usdt", 
                    "displayName": "", 
                    "baseChain": "TRX", 
                    "baseChainProtocol": "TRC20", 
                    "isDynamic": false, 
                    "depositStatus":"allowed",
                    "maxTransactFeeWithdraw":"1.00000000",
                    "maxWithdrawAmt":"280000.00000000",
                    "minDepositAmt":"100",
                    "minTransactFeeWithdraw":"0.10000000",
                    "minWithdrawAmt":"0.01",
                    "numOfConfirmations":999,
                    "numOfFastConfirmations":999,
                    "withdrawFeeType":"circulated",
                    "withdrawPrecision":5,
                    "withdrawQuotaPerDay":"280000.00000000",
                    "withdrawQuotaPerYear":"2800000.00000000",
                    "withdrawQuotaTotal":"2800000.00000000",
                    "withdrawStatus":"allowed"
                },
                {
                    "chain":"usdt",
                    "displayName":"",
                    "baseChain": "BTC",
                    "baseChainProtocol": "OMNI",
                    "isDynamic": false,
                    "depositStatus":"allowed",
                    "maxWithdrawAmt":"19000.00000000",
                    "minDepositAmt":"0.0001",
                    "minWithdrawAmt":"2",
                    "numOfConfirmations":30,
                    "numOfFastConfirmations":15,
                    "transactFeeRateWithdraw":"0.00100000",
                    "withdrawFeeType":"ratio",
                    "withdrawPrecision":7,
                    "withdrawQuotaPerDay":"90000.00000000",
                    "withdrawQuotaPerYear":"111000.00000000",
                    "withdrawQuotaTotal":"1110000.00000000",
                    "withdrawStatus":"allowed"
                },
                {
                    "chain":"usdterc20",
                    "displayName":"",
                    "baseChain": "ETH",
                    "baseChainProtocol": "ERC20",
                    "isDynamic": false,
                    "depositStatus":"allowed",
                    "maxWithdrawAmt":"18000.00000000",
                    "minDepositAmt":"100",
                    "minWithdrawAmt":"1",
                    "numOfConfirmations":999,
                    "numOfFastConfirmations":999,
                    "transactFeeWithdraw":"0.10000000",
                    "withdrawFeeType":"fixed",
                    "withdrawPrecision":6,
                    "withdrawQuotaPerDay": "180000.00000000", 
                    "withdrawQuotaPerYear": "200000.00000000", 
                    "withdrawQuotaTotal": "300000.00000000", 
                    "withdrawStatus": "allowed" 
                } 
| -------------------- | -------- | -------- | ----------------------------------------- -------------------- | ---------------------- |
            ],
            "currency":"usdt",
            "instStatus":"normal" 
        } 
        ] 
} 

``` 

### response data 


| field name | required | data type | field description | value range | 
| code | true | int | status code | | 
| message | false | string | error description (if any) | | 
| data | true | object | | |
| { currency | true | string | currency | |  
{ chains | true | object | | |
| chain | true | string | chain name | | 
| displayName | true | string | chain display name | | 
| baseChain | false 
| false | string | underlying chain protocol | |
| isDynamic | false | boolean | Whether dynamic fee (only valid for fixed type, withdrawFeeType=fixed) | true,false | | 
numOfConfirmations | true | | | 
| numOfFastConfirmations | true | int | Number of confirmations required for fast account transfer (transactions are allowed but withdrawals are not allowed after reaching the number of confirmations) | | | 
| minWithdrawAmt | true | string | single minimum withdrawal amount | | 
| maxWithdrawAmt | true | string | single maximum withdrawal amount | | 
| minDepositAmt | true | string | minimum deposit amount for a single time | |
| depositStatus | true | string | deposit 
status | allowed, prohibited | 
| withdrawQuotaPerDay 
| string | total withdrawal amount | | 
| withdrawPrecision | true | int | withdrawal precision | | 
| withdrawFeeType | true | ,circulated,ratio |
| transactFeeWithdraw | false | string | single withdrawal fee (only valid for fixed types, withdrawFeeType=fixed) | | | minTransactFeeWithdraw | 
false | type is valid, withdrawFeeType=circulated or ratio) | | 
| maxTransactFeeWithdraw | false | string | maximum single withdrawal fee (only valid for interval type and ratio type with upper limit, withdrawFeeType=circulated or ratio) | | | transactFeeRateWithdraw | 
false | string | Fee rate for a single withdrawal (only valid for proportional type, withdrawFeeType=ratio) | | 
| withdrawStatus} | true | string | Withdrawal status | allowed,prohibited |
| instStatus } | true | string | currency status | normal,delisted | 

### status code 

| status code | error message | error scenario description |  
| ------ | ------------- ---------------------- | ------------ | 
| 200 | success | Request succeeded|
| 500 | error | system error | 
| 2002 | invalid field value in "field name " | Illegal field value | 

## Get the current system timestamp 

This interface returns the current system timestamp, that is, the total from **UTC** January 1, 1970 0:00:00:00 milliseconds to now** The number of milliseconds. 

```shell 
curl "https://api.bitv.com/v1/common/timestamp" 
``` 

### HTTP request 

- GET `/v1/common/timestamp` 

### Request parameters 

This interface does not accept any parameter. 

> Response: 

```json 
  "data": 1494900087029 
``` 

# Market Data 

## Introduction

The market data interface provides market data such as various K-lines, depth and latest transaction records. 

The following are the error codes, error messages and descriptions returned by the market data interface. 

| Error Code| Error Message| Description|
| ----------------- | -------------------------------- ---- | ----------------------- | 
| invalid-parameter | invalid symbol | invalid trading pair | 
| invalid-parameter | invalid period | Invalid-parameter | 
invalid depth | depth depth parameter error | | 
invalid-parameter | invalid type | depth type parameter error | | invalid-parameter | 
invalid size | size parameter error | 
| invalid-parameter | invalid size, valid range: [1, 2000] | size parameter error | 
| invalid-parameter | request timeout | request timeout | 


## K-line data (candle chart) 

This interface returns historical K-line data. 

```shell
curl "https://api.bitv.com/market/history/kline?period=1day&size=200&symbol=btcusdt" 
``` 

### HTTP request 

- GET `/market/history/kline` 

### Request parameter 

| Parameter | data type | required | default value | description | range of values ​​| 
| ------ | -------- | -------- | ------ | -------------------------------------------- | ------- -------------------------------------------------- --- | 
| integer | false | 150 | Return the number of K-line data | [1, 2000] | 
| symbol | string | true | NA | trading pair | btcusdt, ethbtc, etc. |
| period | string | true | NA | Return data time granularity, that is, the time interval of each candle | 1min, 5min, 15min, 30min, 60min, 4hour, 1day, 1mon, 1week, 1year | <aside class="notice 

" >The current REST API does not support custom time intervals. If you need historical fixed time range data, please refer to the K-line interface in the Websocket API. </aside> 
<aside class="notice">When obtaining hb10 net value, please fill in "hb10" for symbol. </aside> 
<aside class="notice">The K-line period is calculated based on Singapore time. For example, the starting period of the daily K-line is from 0:00 Singapore time to 0:00 Singapore time the next day. </aside> 

> Response: 

```json 
[ 
  { 
    "id": 1499184000, 
    "amount": 37593.0266, 
    "count": 0, 
    "open": 1935.2000, 
    "close": 1879.0000, 
    "low": 1856.0000, 
    " high": 1940.0000,


| Field Name | Data Type | Description | 
| -------- | -------- | ---------------------- --------------------------------- | 
| id | long | Timestamp adjusted to Singapore time, in seconds, And use it as the id of this K-line column | 
| amount | float | transaction volume measured in base currency | 
| count | integer | number of transactions | 
| open | float 
| Closing price| 
| low | float | Lowest price of this stage| 
| high | float | Highest price of this stage|
| vol | float | Trading volume measured in quote currency | 

## Aggregated Quotes (Ticker) 

This interface obtains ticker information and provides aggregated transaction information for the last 24 hours. 

```shell 
curl "https://api.bitv.com/market/detail/merged?symbol=ethusdt" 
``` 

### HTTP request 

- GET `/market/detail/merged` 

### Request parameter 

| Parameter | data type | required | default value | description | range of values ​​| 
| ------ | -------- | -------- | ------ | ------ | ------------------------------------------- ----------- | 
| symbol | string | true | NA | trading pair | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) | > Response: 

` 

` `json 
{ 
  "id":1499225271, 
  "ts":1499225271000,
  "close":1885.0000, 
  "open":1960.0000, 
  "high":1985.0000, 
  "low":1856.0000, 
  "amount":81486.2926,  
  "count":42122,
  "vol":157052744.85708200,
  "ask":[1885.0000,21.8804], 
  "bid":[1884.0000,1.6702 ] 
} 
``` 

### Response Data 

| Field Name | Data Type | Description | 
| -------- | -------- | -------------- -------------------------- | 
| id | long | NA | 
| amount | float | Amount in base currency (in rolling 24 hours) | 
| count | integer | number of transactions (calculated by rolling 24 hours) | 
| open | float | opening price of this stage (calculated by rolling 24 hours) | | 
close | hour meter) |
| low | float | the lowest price of this period (calculated by rolling 24 hours) | 
| high | float | the highest price of this period (calculated by rolling 24 hours) | | 
vol | float | 24 hours) | 
| bid | object | current highest bid price [price, size] | 
| 
ask | object | current lowest 

ask price [price, size] | 
tickers. 

```shell 
        "open":0.044297, // opening price
curl "https://api.bitv.com/market/tickers" 
``` 

<aside class="notice">This interface returns the tickers of all trading pairs, so the amount of data is large. </aside> 

### HTTP Request 

- GET `/market/tickers` 

### Request Parameters 

This interface does not accept any parameters. 

> Response: 

```json 
[   
    {   
        "close":0.042178, // closing price 
        "low":0.040110, // lowest price 
        "high":0.045255, // highest price 
        "amount":12880.8510,   
        "count":12838 , 
        "vol":563.0388715740, 
        "symbol":"ethbtc", 
        "bid":0.007545, 
        "bidSize":0.008, 
        "
        "open":0.008545,
        "close":0.008656,
        "low":0.008088,
        "high":0.009388,
        "amount":88056.1860,
        "count":16077,
        "vol":771.7975953754,
        "symbol":"ltcbtc",
        "bid":0.007545,
        "bidSize":0.008,
        "ask":0.008088,
        "askSize":0.009 
| open | float | opening price (calculated by natural day in Singapore time) |
| count | integer | number of transactions (calculated by rolling 24 hours) |
| amount | float | Transaction volume measured in base currency (calculated by rolling 24 hours) |
| -------- | ----- --- | ------------------------------------------- |
| field name | data type | description |
Core response data is an object column, each object contains the following fields
### Response data
```
]
    }


 
| close | float | latest price (according to natural day in Singapore time) | 
| 
float | the highest price (in Singapore time) | | 
vol | float | volume in quote currency (rolling 24 hours) | 
| symbol | string | Trading pairs, such as btcusdt, ethbtc | 
| bid | float | buy one price| | 
bidSize 
| 
| askSize | float | Ask Size | 

## Market Depth Data 

This interface returns the current market depth data of the specified trading pair. 

```shell 
curl "https://api.bitv.com/market/depth?symbol=btcusdt&type=step2" 
``` 

### HTTP request 

- GET `/market/depth` 

### Request parameters
 
| parameter| Data type | Required | Default value | Description | Range of values ​​| 
| ------ | -------- | ----- | ------ | ------ -------------------------- | ----------------------- ---------------------------------- |
| symbol | string | true | NA | trading pair | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) | | depth 
| , 20 | 
| type | string | true | step0 | In-depth price aggregation, see below for details | step0, step1, step2, step3, step4, step5 | <aside class="notice"> 

when the type value is 'step0' , the default value of 'depth' is 150 instead of 20. </aside> 

**Description of each value of parameter type** 

| Value| Description| 
| ----- | --------------------- | 
| step0 | No aggregation| 
    "ts": 
| step1 | Aggregation degree is quotation precision * 10 | 
| step2 | Aggregation degree is quotation precision * 100 |
| step3 | Aggregation degree is quotation precision*500 | 
| step4 | Aggregation degree is quotation precision*1000 | 

> Response: 

```json 
{ 
    "version": 31615842081, 
    "bids": [ 
      [7964, 0.0678], // [ price, size] 
      [7963, 0.9162], 
      [7961, 0.1], 
      [7960, 12.8898], 
      [7958, 1.2], 
      ... 
    ], 
    "asks": [ 
      [7979, 0.0736], 
      [7980, 1.0292], 
      [7981, 5.5652], 
      [7986, 0.2416], 
      [7990, 1.9970], 
      ... 
    ] 
  } 
``` 

### Response data 

<aside class="notice"> The JSON top-level data object returned is named 'tick' instead of the usual 'data'. </aside>
 
| field name | data type | description | 
| -------- | -------- | -------------------------------- -- | 
| ts | integer | Timestamp adjusted to Singapore time, in milliseconds | 
| version | integer | internal field |
| bids | object | all current 
buy orders [price, size] | | 

asks 

| 

```shell 
curl "https://api.bitv.com/market/trade?symbol=ethusdt" 
``` 

### HTTP request 

- GET `/market/trade` 

### request parameter 
 
| parameter | data type | Required | Default | Description | 
| ------ | -------- | -------- | ------ | -------- ---------------------------------------------- |
| symbol | string | true | NA | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) | 

> Response: 

```json 
{ 
    "id": 600848670, 
    "ts": 1489464451000, 
    "data": [ 
      { 
        "id": 600848670, 
        "trade-id": 102043494568, 
        "price": 7962.62, 
        "
        "direction": "buy", 
        "ts": 1489464451000 
      } 
    ] 
} 
``` 

### response data 
 
<aside class="notice">The returned JSON top-level data object is named 'tick' instead of the usual 'data'. </aside>

| id | integer | unique transaction id (will be discarded) | 
| trade-id | integer | unique transaction ID (NEW ) | 
| amount | float | transaction volume in base currency | 
| price | float | transaction price in quote currency | 
| ts | integer | timestamp adjusted to Singapore time, in milliseconds | | 
direction | string | Transaction direction: "buy" or "sell", "buy" means buying, "sell" means selling | 

## Get recent transaction records 

This interface returns all recent transaction records of the specified trading pair. 

```shell 
curl "https://api.bitv.com/market/history/trade?symbol=ethusdt&size=2"


- GET `/market/history/trade` 

### request parameters
 
| parameter | data type | required | default value | description |
| ------ | -------- | -------- | ------ | ----------------- ------------------------------------- | 
| symbol | string | true | NA | btcusdt, ethbtc ... (Refer to `GET /v1/common/symbols` for value) | 
| size | integer | false | 1 | The number of transaction records returned, the maximum value is 2000 | 

> Response: 

```json 
[   
   {   
      "id": 31618787514, 
      "ts":1544390317905, 
      "data":[   
         {   
            "amount":9.000000000000000000, 
            "ts":1544390317905, 
            "trade-id": 102043483472, 
            "id":316187875141891 8529341, 
            "price":94.690000000000000000,
            "direction":"sell"
         },
         {  
            "amount":73.771000000000000000,
            "ts":1544390317905,
            "trade-id": 102043483473
            "id":3161878751418918532514,
            "price":94.660000000000000000,
            "direction":"sell"
         }
      ]
   },
   {  
      "id":31618776989,
      "ts":1544390311353,
      "data":[  
         {  
            "amount":1.000000000000000000,
            "ts":1544390311353,
            "trade-id": 102043494568,
            "id":3161877698918918522622,
            "price":94.710000000000000000, 
            "direction":"buy"
         }
      ] 
   } 
] 
``` 

### Response data 

<aside class="notice"> The returned data object is an array of objects, and each array element is a timestamp adjusted to Singapore time (in milliseconds ), which are presented as an array. </aside> 

| parameter | data type | description | 
| --------- | -------- | ------------------ -------------------------------- | 
| id | integer | unique transaction id (will be obsolete) | 
| trade- id | integer | unique transaction ID (NEW) | 
| amount | float | transaction volume in base currency | 
| price | float | transaction price in quote currency | 
| ts | integer | Timestamp in milliseconds|
| direction | string | Trading direction: "buy" or "sell", "buy" means buying, "sell" means selling | ## Last 

24 hours market data 

This interface returns the latest 24 hours market data summary.  
   "high":

```shell 
curl "https://api.bitv.com/market/detail?symbol=ethusdt" 
``` 

### HTTP request 

- GET `/market/detail` 

### Request parameter 

| parameter | data type | Required | Default | Description | 
| ------ | -------- | -------- | ------ | -------- ------------------------------------------------- | 
| symbol | string | true | NA | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) | 

> Response: 

```json 
{   
   "amount":613071.438479561, 
   "open":86.21, 
   "close" :94.35, 
   "count":138909, 
   "low":84.63, 
   "version":31619471534,
   "vol":5.6617373443873316E7
   "id":31619471534, 
} 
``` 

### Response data 

<aside class="notice">The JSON top-level data object returned is named 'tick' instead of the usual 'data'. </aside>

| version | integer | internal data | 


## Introduction 

The account-related interface provides functions such as account, balance, history query and asset transfer. 

<aside class="notice">Access to account-related interfaces requires signature authentication. </aside> 

The following are the error codes, error messages and descriptions returned by account-related interfaces. 

| Error Code | Error Message | Description | 
| ------ | --------------------------------- ---------- | --------------------------------------- ------------ | 
| 500 | system error | Abnormal call to internal service | 
| 1002 | forbidden | Forbidden operation, such as the accountId and UID in the user input parameters are inconsistent | 
| 2002 | "invalid field value in `currency`" | currency does not conform to regular rules ^[a-z0-9]{2,10}$ | 
| 2002 | "invalid field value in `transactTypes`" | The transfer type transactTypes is not "transfer" | 
| 2002 | "invalid field value in `sort`" | Paging request parameters are not valid"
| 2002 | "value in `fromId` is not found in record” | fromId not found | 
| 2002 | "invalid field value in `accountId`" | accountId in the query parameter is empty| 
| 2002 | "value in `startTime` exceeded valid range" | The input query time is greater than the current time, or more than 180 days from the current time| 
| 2002 | "value in `endTime` exceeded valid range") | The query end time is less than the start time, or the query time span is greater than 10 days| 

## Account Information 

API Key Permission: Read<br> 
Frequency Limit (NEW): 100 times/2s 

Query all account ID `account-id` and related information of the current user 
      "type":"spot",
      "subtype": "",
 
### HTTP request

- GET `/v1/account/accounts` 

### Request parameter 

None 

> Response: 

```json 
{ 
  "data": [ 
    { 
      "id": 100001, 
      "state": "working" 
    } 
  ] 
} 
``` 

# ## Response data 

| Parameter name | Required | Data type | Description | Value range | 
| -------- | -------- | -------- | -- -------- | ------------------------------- | 
| id | true | long | id | | 
| state | true | string | account status | working: normal, lock: account is locked | 
| type | true | string | account type | spot: spot account | 

## account balance 

API Key permission: read<br >
Frequency limit value (NEW): 100 times/2s 

to query the balance of the specified account, the following accounts are supported: 

spot: spot account 

### HTTP request 

- GET `/v1/account/accounts/{account-id}/balance` 

## # Request parameter
        "currency": "usdt",

| Parameter name | Required | Type | Description | Default value | Value range | 
| ---------- | -------- | ------ | ---- -------------------------------------------------- ------ | ------ | -------- | 
| account-id | true | string | account-id, fill in path, refer to `GET /v1/account for value /accounts` | | | 

> Response: 

```json 
{ 
  "data": { 
    "id": 100009, 
    "type": "spot", 
    "state": "working", 
    "list": [ 
      { 
        "type" : "trade", 
        "balance": "5007.4362872650" 
      }, 
      { 
        "currency":"usdt",
        "type": "frozen",
        "balance": "348.1199920000"
| parameter name | required | data type | description | value range |
list field description
| list | false | Array | | |
| type | true | string | account type | spot: spot account |
| state | true | string | account status | working: normal lock: account is locked |
| id | true | long | account ID | |
| -------- | -------- | --- ----- | -------- | ------------------------------- |
| Parameter name | Required | Data type | Description | Value range |
### Response data
```
}
  }
    ]
      }




| -------- | -------- | -------- | ---- | ----------------- ---------------- | 
| balance | true | 
string | balance | | | currency 
| true | Balance, frozen: Frozen balance | 

## Obtain account asset valuation 

API Key Permission: Read 

Frequency limit value (NEW): 100 times/2s 

According to BTC or legal currency denomination unit, get the total asset valuation of the specified account. 

### HTTP Request 

- GET `/v2/account/asset-valuation` 

### Request Parameters 

| Parameters | Required | Data Type | Description | Default Value | Range of Values ​​| 
| -------- --------- | -------- | -------- | ------------------- ----------------------------------- | ------ | ------- ------------------------------ | 
| accountType | true | string | account type | NA | spot : spot account | 
| valuationCurrency | false | string | asset valuation fiat currency, that is, which fiat currency is used to value assets. | BTC | Optional fiat currency: BTC, USD (case sensitive) | 
| subUid | false | long | UID of the sub-user, if not filled, returns the account asset valuation of the user whose API key belongs | NA | | > 

Responds : 

```json 
{ 
    "code": 200, 
    "data": { 
        "balance": "34.75", 
        "timestamp": 1594901254363 
    }, 
    "
``` 


| balance | true | string | total asset valuation according to a certain fiat currency | | timestamp | true | long | data 
return 
time, unix time in millisecond 
| br> 
This node is a general interface for asset transfer between parent users and sub-users. <br> 
Only the functions supported by the parent user include:<br> 
1. Transfer between the currency account of the parent user and the currency account of the sub-user;<br> 
2. Transfer between currency accounts of different sub-users;<br> 
Only the functions supported by sub-users include: <br> 
1. The sub-user currency account is transferred to other sub-user currency accounts under the parent user. This permission is disabled by default and requires authorization from the parent user. The authorization interface is `POST /v2/sub-user/transferability`;<br> 
2. Transfer from the currency account of the sub-user to the currency account of the parent user;<br> 
Other transfer functions will be launched gradually, so stay tuned. <br> 
### HTTP Request 
- POST `/v1/account/transfer` 
### Request Parameters 
| Parameter | Required | Data Type | Description | Value Range |










 
| ----------------- | -------- | -------- | -------------------------------------- | ---- ---------------------------- |
| from-user | true | long | transfer-out user uid | parent user uid, sub-user uid | | 
from-account-type | true | string | transfer-out account type | spot | 
| long | transfer- in 
user uid | parent user uid, sub-user uid | 
| currency | true | Types, namely btc, ltc, bch, eth, etc ... | Value reference GET /v1/common/currencys | 
| to-account-type | true | |
| to-account | true | long | transfer-in account id | | 
| amount | true | string | transfer amount| | 


> Response: 

```json 
{ 
    "status": "ok", 
    "data": { 
        "transact -id": 220521190, 
        "transact-time": 1590662591832 
    } 
} 
``` 

### Response data 

| Parameter | Required | Data type | Description | Value range | 
| ----------- ---- | -------- | -------- | ---------- | --------------- | 
| status | true | string | status | "ok" or "error" |
|
| transact-time } | true | long
| { transact -id | true | int | transaction serial number | |
| data | true | list | | |



API Key Permission: Read<br> 
Frequency Limit (NEW): 5 times/2s 

The node returns the account history based on the user account ID. 

### HTTP Request 

- GET `/v1/account/history` 

### Request parameter
 
| parameter name | required | data type | description | default value | value range | 
| --------- ----- | -------- | -------- | -------------------------- ---------------------------------- | --------------- ----- | -------------------------------------------- ---------------- |
| account-id | true | string | account number, refer to `GET /v1/account/accounts` for value | | | | 
currency | false | string | currency, namely btc, ltc, bch, eth, etc ... (Refer to `GET /v1/common/currencys` for value) | | | 
| transact-types | false | string | Change types, multiple choices, separated by commas | all | fee), fee-deduction (deduction of service fee), transfer (transfer), deposit (recharge), withdraw (withdrawal), withdraw-fee (withdrawal fee), other-types (other), rebate ( transaction rebate) |
| start-time | false | long | Unix time in millisecond. Use transact-time as the key to search. The maximum query window is 1 hour. The window translation range is the last 30 days. | ((end-time) – 1hour ) | [((end-time) – 1hour), (end-time)] | 
| end-time | false | long | unix time in millisecond. Retrieve with transact-time as the key. The maximum query window is 1 hour. The panning range of the window is the last 30 days. | current-time | [(current-time) – 29days,(current-time)] | | sort | false | string | search direction | asc | asc or desc | 
| 
size | false | int | maximum number of entries | 100 | [1,500] |
| from-id | false | long | starting number (only valid when querying on the next page) | | | 

> Response: 

```json 
{ 
    "status": "ok", 
    "data": [ 
        {  
            "account-id": 5260185,
            "currency": " btc", 
            "transact-amt": "0.002393000000000000", 
            "transact-type": "transfer", 
            "record-id": 89373333576, 
            "avail-balance": "0.002393000000000000", 
            "acct-balance": "0.002393000 000000000" , 
            "transact-time":1571393524526
        },
        {
            "account-id": 5260185,
            "currency": "btc",
            "transact-amt": "-0.002393000000000000",
            "transact-type": "transfer",
            "record-id": 89373382631,
            "avail-balance": "0E-18",
            "acct-balance": "0E-18",
            "transact-time":1571393578496 
| data | object | | |
| status | string | status code | |
| ------------- | -------- | ---- --------------------------------------------------- | - ------- |
| field name | data type | description | value range |
### response data
        }
    ]
}
```


| { account-id | long | account number| | 
| currency | string | currency | 
| | transact 
-amt | type | | 
| avail-balance | string | available balance | | 
| acct-balance | string | account balance | |
| transact-time | long | transaction time (database record time) | | 
| record-id } | long | database record number (globally unique) | | | 
next-id | long | Include this field when pagination is required) | | 

## Financial History 

API Key Permission: Read 

This node returns financial history based on the user account ID. <br> 
For the time being, the first phase of online only supports the query of transfer transactions ("transactType" = "transfer"). <br> 
The query window framed by "startTime"/"endTime" is up to 10 days, which means that the range that can be retrieved through a single query is up to 10 days. <br> 
The query window can be shifted within the range of the last 180 days, that is, by querying the shifted window multiple times, the records of the past 180 days can be retrieved at most. <br> 

### HTTP Request 

- GET `/v2/account/ledger` 

### Request parameter 

| Parameter name | Data type | Required | Description | 
| ------------- | -------- | -------- | -------------------------------- ------------------- | 
| accountId | string | TRUE | Account ID | 
| currency | string | FALSE | Currency (default value is all currencies) | 
| transactTypes | string | FALSE | Change type, can be filled in more (default value is all) Enumeration value: transfer | | 
startTime | long | FALSE | See note 1 for value range and default value) |
| endTime | long | FALSE | near point time (see note 2 for value range and default value) | 
| sort | string | FALSE | search direction (asc from far to near, desc from near to far, default value desc) | 
| limit | int | FALSE | The maximum number of returned items on a single page [1,500] (default value 100) | | 
fromId | long 

| <br> 
startTime value range: [(endTime - 10 days), endTime], unix time in millisecond<br> 
startTime default value: (endTime - 10 days) 

Note 2: <br> 
endTime value range: [( current time - 180 days), current time], unix time in millisecond<br> 
endTime default: current time 

> Response: 

```json 
{ 
"code": 200, 
"message": "success", 
"data" :[
    {
        "accountId": 5260185,
        "currency": "btc",
        "transactAmt": 1.000000000000000000,
        "transactType": "transfer",
        "transferType": "margin-transfer-out",
        "transactId": 0,
        "transactTime": 1585573286913,
        "transferer": 5463409,
        "transferee": 5260185
    },
    {
        "accountId": 5260185,
        "currency": "btc",
        "transactAmt": -1.000000000000000000,
        "transactType": "transfer",
        "transferType": "margin-transfer-in",
        "transactId": 0,
        "transactTime": 1585573281160,
        "transferer": 5260185, 
        "transferee": 5463409 
    } 
]
}
``` 

### response data 

| field name | data type | required | description | value range | 
| ------------ | -------- | -------- | -------------------------------- ---------------------------- | --------------------- --------------------------------------- | 
| code | integer | TRUE | status code| | 
| message | string | FALSE | error description (if any) | |
| data | object | TRUE | sorted in the order defined in the user request parameter sort | | 
| transactType | string | TRUE | Change type | transfer |
| { accountId | integer | TRUE | account number | | 
| currency | string | TRUE | 
currency | | | transactAmt 
| | Transfer type (only valid for transactType=transfer) | master-transfer-in (transfer to parent user), master-transfer-out (transfer from parent user), sub-transfer-in (transfer to sub-user ), sub-transfer-out (transfer from sub-user) | 
| transactId | integer | TRUE | transaction serial number | | 
| transactTime | integer | TRUE | transaction time | | 
| transferer | integer | FALSE | Payer Account ID | | 
| transferee } | integer | FALSE | payee account ID | 
| (This field is only included when the query results need to be returned in pages, see Note 3.) | |Note 3 

:<br> 
Only when the data entries in the time range that the user requests to query exceeds the limit of a single page (set by the "limit" field ), the server returns the "nextId" field. After the user receives the "nextId" returned by the server –<br> 
1) It must be known that there is still data that cannot be returned on this page;<br>
2) If you need to continue to query the next page of data, you should request the query again and use the "nextId" returned by the server as "fromId", and keep other request parameters unchanged. <br> 
3) As the database record ID, "nextId" and "fromId" have no other business meaning except for page turning query. <br> 

# Wallet (Deposit and Withdrawal Related) 

## Introduction 

The deposit and withdrawal related interface provides functions such as deposit address, withdrawal address, withdrawal amount, deposit and withdrawal records, etc., as well as withdrawal and cancellation of withdrawals. 

<aside class="notice">Signature authentication is required to access the interfaces related to deposit and withdrawal. </aside> 

The following are the return codes, return messages and instructions returned by the relevant interface of deposit and withdrawal. 

| Return code| Return message| Description| 
|  
| ------ | --------------------------------- --- | ------------ |
200 | success | Request succeeded| 
| 500 | error | System error| 
| 
1002 | "field name" | Illegal field value | 
| 2003 | missing mandatory field "
 
## Coin deposit address query 

This node is used to query the coin deposit address of a specific currency (except IOTA) in its blockchain, both parent and child users can use the 

API Key permission: read<br> 
frequency limit value (NEW) : 20 times/2s 

<aside class="notice"> Deposit address query does not support IOTA coins</aside> 

```shell 
curl "https://api.bitv.com/v2/account/deposit/address? currency=btc" 
``` 

### HTTP request 

- GET ` /v2/account/deposit/address` 

### Request parameter

| field name | required | type | field description | value range | 
| -------- | -------- | ------ | -------- | -------------------------------------------------- ----------- | 
| currency | true | string | currency | btc, ltc, bch, eth, etc ... (refer to `GET /v1/common/currencys`) | 

> Response: 

```json 
{ 
    "code": 200, 
    "data": [ 
        { 
            "currency": "btc", 
            "address": "1PSRjPg53cX7hMRYAXGJnL8mqHtzmQgPUs", 
            "addressTag": "", 
            "chain": "btc"
        } 
    ] 
} 
``` 

### response data 


| field name | required | data type | field description | value range |
| ---------- | -------- | -------- | ---------------- | --- ----- | 
| code | true | int | status code | | 
| message | false | string | error description (if any) | | 
| data | true | object | | | 
| {currency | true | string | type | | 
| 1002 | unauthorized | unauthorized|
string | deposit address | | | addressTag | true |
currency | | address | true |
| chain } | true | string | chain name | | 

### status code 

| status code | error message | error scenario description | 
| ------ | -------------- ---------------------- | ------------ | 
| 200 | success | request successful | 
| 500 | error | system Error | 
| 1003 | invalid signature | signature verification failed | 
| 2002 | invalid field value in "field name" | illegal field value | 
| 2003 | missing mandatory field "field name" 

| 

This node is used to query the withdrawal amount of each currency, and only the parent user can use 

the API Key permission: read<br> 
Frequency limit value (NEW): 20 times/2s 

```shell 
curl "https://api.bitv. com/v2/account/withdraw/quota?currency=btc" 
```
 
### HTTP request 

- GET ` /v2/account/withdraw/quota` 

### request parameter 

| field name | required | type | field description | fetch Value range | 
| -------- | -------- | ------ | -------- | ------------ --------------------------------------------------- | 
| currency | true | string | Currency | btc, ltc, bch, eth, etc ... (value reference `GET /v1/common/currencys`) | 

> Response: 

```json 
{ 
    "code": 200, 
    "data": 
        { 
            "currency": "btc ", 
            "chains": [ 
                { 
                    "chain": "btc", 
                    "maxWithdrawAmt": "200.00000000", 
                    "withdrawQuotaPerDay": "200.00000000",
                    "remainWithdrawQuotaPerDay": "200.000000000000000000",
                    "withdrawQuotaPerYear": "700000.00000000", 
                    "remainWithdrawQuotaPerYear": "700000.000000000000000000", } 
                    "withdrawQuotaTotal": "7000000.00000000",
                    "remainWithdrawQuotaTotal": "7000000.000000000000000000"
                }
        ] 
    } 
` 
`` 

### Response data 

| field name | required | data type | field description | value range | 
| ----- --------------------- | -------- | -------- | ---------- ------ | -------- | 
| code | true | int | status code | | 
| message | false | string | error description (if any) | | 
| data | true | object | | | 
| currency | true | string | currency | |
| chains | true | object | | | 
| { chain | true | string | chain name | | 
maxWithdrawAmt 
| 
### status code
| remainWithdrawQuotaPerDay | true | string | The remaining 
withdrawal amount of the day| | | 
withdrawQuotaPerYear | 
true | string | Currency Quota| | 
| remainWithdrawQuotaTotal } | true | string | Total remaining withdrawal quota| | | 
| 1002 | unauthorized | Unauthorized |


| Status Code | Error Message | Error Scenario Description | 
| ------ | ---------------------------- ---- | ------------ | 
| 200 | success | Request succeeded | 
| 500 | error | System error | 
| 1003 | invalid signature | Signature verification failed | 
| 2002 | invalid field value in "field name" | Illegal field value | 

## Withdrawal Address Query 

API Key Permission: Read<br> 

This node is used to query the withdrawal address available for the API key, which is only available to parent users. <br> 

### HTTP request 

- GET `/v2/account/withdraw/address` 

### Request parameter 

| parameter name | required | type | description | default value | value range |
| -------- | -------- | ------ | ------------------------ ------------------------------ | ------------------- ----------- | -------------------------------------- ---------------------- | 
| note | false | string | Address Remarks| If not filled, return the withdrawal address of all remarks| | 
| limit | false | int | Maximum number of items returned on a single page| 
| currency | true | string | Currency | | btc, ltc, bch, eth, etc ... (Refer to `GET /v1/common/currencys`) |
| chain | false | string | chain name | If not filled, return the withdrawal addresses of all chains | | |                                                               fromId 
| false | | NA | | 

> Response: 

```json 
{ 
    "code": 200, 
    "data": [ 
        { 
            "currency": "usdt", 
            "chain": "usdt", 
            "note": "Binance", 
            " addressTag": "", 
            "address": "15PrEcqTJRn4haLeby3gJJebtyf4KgWmSd"
        } 
    ] 
} 
``` 

### Response data
 
| Parameter Name | Required | Data Type | Description | Value Range | 
| ---------- | -------- | -------- | ---- -------------------------------------------------- ------ | -------- | 
| code | true | int | status code | | 
| message | false | string | error description (if any) | | 
| data | true | object | | | 
| { currency | true | string | currency | | 
| chain | true | string | chain name | |
string | address note | | 
addressTag | false | string | address tag, if any | | | 
address } 
| true | Currency address ID, this field is included only when the query results need to be returned in pages, see the remarks for details) | |Remarks: 

<br> 
Only when the data entry requested by the user exceeds the limit of a single page (set by the "limit" field) , the server returns the "nextId" field. After the user receives the "nextId" returned by the server –<br> 
1) Be aware that there is still data that cannot be returned on this page;<br> 
2) If you want to continue to query the data on the next page, you should request the query again and return the server "nextId" is used as "fromId", and other request parameters remain unchanged. <br> 
3) As the database record ID, "nextId" and "fromId" have no other business meaning except for page turning query. <br> 


## Virtual Currency Withdrawal 

This node is used to withdraw the digital currency of the spot account to the blockchain address (already exists in the withdrawal address list) without multiple (SMS, email) verification, only available to parent users

API Key Permission: Withdrawal<br>  
Frequency limit (NEW): 20 times/2s

<aside class="notice">If the user has set priority to use fast withdrawal in personal settings</a>, the withdrawal initiated through the API will also give priority to the fast withdrawal channel. Quick coin withdrawal means that when the target address of the coin withdrawal is the internal user address of the platform, the coin withdrawal will go through the fast channel inside the platform instead of the blockchain. </aside> 
<aside class="notice">API withdrawal only supports the addresses in the user withdrawal address list</a>. The IOTA one-time withdrawal address cannot be set as a common address, so IOTA withdrawal through API is not supported. </aside> 

### HTTP Request 

- POST ` /v1/dw/withdraw/api/create` 

> Request: 

```json 
{ 
  "address": "0xde709f2102306220921060314715629080e2fb77", 
  "amount": "0.05", 
  "currency" : "eth", 
  "fee": "0.01"


| address | true | string | withdrawal address | only supports addresses in the corresponding currency address list on the official website | 
| amount | true | string | withdrawal amount | | 
| currency | true | string | asset type | btc, ltc , bch, eth, etc ... (refer to `GET /v1/common/currencys` for values) |  
| fee | true | string | transfer fee | |
| chain | false | This parameter must be set to "usdt". When withdrawing USDT to TRX, this parameter must be set to "trc20usdt". This parameter does not need to be set for other currency withdrawals | | | addr-tag | false | 
string | virtual currency shared address tag, applicable For xrp, xem, bts, steem, eos, xmr | format, "123"class integer string |
 
> Response: 

```json 
{ 
  "data": 700 
} 
``` 

### Response data 


| Parameter name | Required | Data type | Description | Value range | 
| -------- | -- ------ | -------- | ------- | -------- | 
| data | false | long | withdrawal ID | | 


## Cancel withdrawal 

This node is used to cancel the submitted coin withdrawal request, limited to the parent user’s available 

API Key permission: coin withdrawal<br> 
Frequency limit (NEW): 20 times/2s 

### HTTP request

- POST `/v1/dw/withdraw-virtual/{withdraw-id}/cancel` 

### request parameter 

| parameter name | required | type | description | default value | value range | 
| ------ ----- | -------- | ---- | --------------------- | ------ |- ------- | 
| withdraw-id | true | long | Withdrawal ID, fill in the path | | | 


> Response: 

```json 
{ 
  "data": 700 
} 
``` 

### Response data 


| Parameter name | Required | Data type | Description | Value range | 
| -------- | -------- | -------- | ------ - | -------- | 
| data | false | long | Withdrawal ID | | 

## Deposit and withdrawal records 

This node is used to query deposit and withdrawal records, both parent and child users can use 

API Key permission: read<br> 
Limit value (NEW): 20 times/2s 

### HTTP request 

- GET `/v1/query/deposit-withdraw`
 
### request parameter 

| parameter name | Required | Type | Description | Default | Value Range | 
| -------- | -------- | ------ | --------- ------- | ------------------------------------------ ------------------ | ------------------------------- -------------------------------- |
| currency | false | string | currency | | btc, ltc, bch, eth, etc ... (value reference `GET /v1/common/currencys`) | | type | true | string 
| | deposit or withdraw, only deposit is available for sub-users | 
| from | false | string | query starting ID | By default, the default value is direct. When direct is 'prev', from is 1, return from old to new in ascending order; when direct is 'next', from is the ID of the latest record, and return from new to old in descending order | | | direct | false | string 
  "data": 
    [ 
| Query record size | 100 | 1-500 |
| direct | false | string | return record sorting direction | By default, the default is "prev" (ascending order) | "prev" (ascending order) or "next" (descending order) | > Response: ``` 

json 

{ 
{ 
      " 
        id ": 1171, 
        "type": "deposit", 
        "currency": "xrp", 
        "tx-hash": "ed03094b84eafbe4bc16e7ef766ee959885ee5bcb265872baaa9c64e1cf86c2b", 
        "amount": 7.457467, 
        "address": "rae93V8d2mdoUQHwBDBdM4NHCMehRJAsbm", 
        "address-tag": "100040", 
        "fee": 0, 
        "state": "safe", 
        "created-at":1510912472199,
        "updated-at": 1511145876575
      },
      ...
    ]
} 
``` 
| tx-hash | true | string | transaction hash | |


| parameter name | required | data type | description | value range |
### response data
| ----------- | -------- | -------- | ---------------- -------------------------------------------- | -------- -------------------------------- | 
| id | true | long | deposit order id | | 
| type | true | string | type | 'deposit', 'withdraw', sub-user only deposit | 
| currency | true | string | currency | | 
| chain | true | string | chain name | |
| amount | true | float | number | | 
address | true | string | destination address | | 
| address-tag | true | string  destination address 
| | float | handling fee| |
| address tag | | | state 
| error-code | false | string | Withdrawal failure error code, only when the type is "withdraw" and the state is "reject", "wallet-reject" and "failed". | | 
| error-msg | false | failed" from time to time. | | 
| created-at | true | long | launch time | | 
| updated-at | true | long | last update 


time 

| 
| -- | -------- | 
| unknown | status unknown | 
| confirming | confirming | 
| confirmed | confirmed | 
| 
safe | completed | 
| 

orphan 

| --------------- | ------------ | 
| verifying | pending verification | 
| failed 
| 
verification failed | 
| submitted | 
| pass | approved | 
| rejected | approved rejected | 
| pre-transfer | processing | 
| wallet-transfer | remitted | 
| 
wallet 
-reject | Block Confirmation Error | 
| repealed | Revoked | 
# Sub-User Management 
## Introduction 
Sub-user management interface provides sub-user creation, query, permission setting, transfer, sub-user API Key creation, modification, query, deletion, sub-user Functions such as deposit and withdrawal address and balance inquiry. 
<aside class="notice">Signature authentication is required to access related interfaces of sub-user management. </aside>






The following are the return codes, return messages, and descriptions returned by sub-user-related interfaces. 

| Error Code | Return Message | Description | 
| ------ | --------------------------------- ------------------------ | ------------------------- --------- | 
| 1002 | "forbidden" | Forbidden operations, such as the account is not allowed to create sub-users | 
| 1003 | "unauthorized” | Unauthenticated | 
| 2002 | invalid field value | parameter error | 
| 2014 | number of sub account in the request exceeded valid range | The number of sub-accounts has reached the limit | 
| 2014 | number of api key in the request exceeded valid range | The number of API Keys has exceeded the limit |
| 2016 | invalid request while value specified in sub user states | Freeze/Unfreeze failed | 


## Sub-user Creation 
 
unfreeze Created by users, up to 50 at a time

API Key Permission: Transaction 

### HTTP Request 

- POST `/v2/sub-user/creation` 

> Request: 

`` `json 
{ 
"userList": 
  [ 
    { 
      "userName":"test123", 
      "note":"123" 
    }, 
    { 
      "userName":"test456", 
      "note":"123" 
    } 
  ] 
} 
``` 

## # Request parameter 

| parameter name | required | type | description | default value | range of values ​​|
| userList | true | object |
| ----------- | -------- | ------ | ---------- --------------------------------------- | ------ | ------ -------------------------------------------------- ---- |
| [{ userName | true | string | Sub-username, an important identification of sub-user identity, requires uniqueness within the platform | NA | A combination of 6 to 20 letters and numbers, which can be pure letters; if a combination of letters and numbers, it needs to be Start with a letter; letters are not case-sensitive; | 
| note }] | false | string | Sub-user note, no unique requirement | NA | Up to 20 characters, unlimited character types | > Response: `` 

` 

json 
{ 
    " code": 200, 
    "data": [ 
        { 
    "userName": "test123", 
    "note": "123", 
    "uid": 123 
      }, 
        {  
    "userName": "test456",
    "note": "123",
    "errCode": "2002",
    "errMessage": "value in user name duplicated with existing record"
      } 
    ] 
} 
``` 

### response data 

| parameter name | required | data type | description | value range | 
| ------------- | -------- | - ------- | ------------------------------------------ -- | -------- | 
| code | true | int | status code | | 
| message | false | string | error description (if any) | | 
| data | true | object | | | | 
[{ userName | true | string | sub-user name | | 
| note | false | string | sub-user notes (only valid for sub-users with notes) | | 
| uid | false | long | valid for successful sub-users) | | 
| errCode | false | string | error code for creation failure (only valid for sub- 
users Sub-user is valid) | | 

## Get the list of sub-users


Through this interface, the parent user can obtain the UID list of all sub-users and the API Key permission 
of each user status : read 

### HTTP request 

- GET `/v2/sub-user/user-list` 

### request parameter 

| parameter name | Required | Type | Description | Default | Value Range | 
| -------- | -------- | ---- | ----------- --------------------- | ------ | -------- | 
| fromId | FALSE | long | query starting number ( Only valid for page turning query) | | | 

> Response: 

```json 
{ 
    "code": 200, 
    "data": [ 
``` 
        {
            "uid": 63628520,
            "userState": "normal"
        },
        {
            "uid": 132208121,
            "userState": "normal"
| data | TRUE | object | | |
| message | FALSE | string | error description (if any) | |
| code | TRUE | int | status code | |
}
    ]
        }

### Response data 

| Parameter name | Required | Data type | Description | Value range | 
| ----------- | -------- | ------- - | -------------------------------------------- | ----- ------- | 
| parameter | required | data type | length | description | value range |
| { uid | TRUE | long | Sub-user UID | | 
| userState } | TRUE | string | Sub-user state | lock, normal | 
| nextId | FALSE | Return) | | 

##Freeze/Unfreeze Sub-User 

API Key Permission: Transaction<br> 
Frequency Limit (NEW): 20 times/2s 

This interface is used by the parent user to freeze and unfreeze the next sub-user 

### HTTP Request 

- POST `/v2/sub-user/management` 

### Request Parameters 

| ------ | -------- | -------- | ---- | ----------- | ------------------------ | 
| subUid | true | long | - | UID of subuser | - | 
| action | true | string | - | operation type | lock (freeze), unlock (unfreeze) | > 

Response: 

```json 
{
  "code": 200, 
	"data": { 
     "subUid": 12902150, 
     "userState":"lock"} 
} 
``` 

### Response data 

| parameter | required | data type | length | description | value range |  
| --------- | -------- | -------- | ---- | ---------- | -------------------------- | 
| subUid | true | long | - | sub user UID | - |
| userState | true | string | - | Sub-user status | lock (frozen), normal (normal) | 


## Get the user status of a specific sub-user The master user can get the user status 
API Key 

of a specific sub-user through this interface 
Permission: read 

### HTTP request 

- GET `/v2/sub-user/user-state` 

### request parameter 

| parameter name | required | type | description | default value | value range | 
| --- ----- | -------- | ---- | --------- | ------ | -------- | 
| subUid | TRUE | long | Subuser UID | | | 

> Response: 

```json 
{ 
    "code": 200,
    "data": {
        "uid": 132208121, 
        "userState": "normal" 
    } 
} 
``` 
 
### Response data 

| Parameter name | Required | data type | description | value range |
| ----------- | -------- | -------- | - --------------- | ------------ | 
| code | TRUE | int | status code | | 
| message | FALSE | string | error description ( if any) | | 
| data | TRUE | object | | | 
| { uid | TRUE | long | sub-user UID | | 
| userState } | TRUE | string 

| 

API Key Permission: Transaction 

This interface is used by the parent user to set the transaction permission of sub-users in batches. 
The sub-user's spot trading authority is enabled by default and does not need to be set. 

###HTTP request 

- POST `/v2/sub-user/tradable-market` 

### Request parameters

| Parameter | Mandatory | Data Type | Length | Description | Value Range | 
| ----------- | -------- | -------- | - --- | ------------------------------------------------ | ---------------------------- | 
| subUids | true | string | - | Sub-user UID list (multiple filling is supported, up to 50 string | - 
| accountType | true | string | - | account type | isolated-margin,cross-margin | | 
activation | true | string | - | account activation status | activated, deactivated | 

> Response: 

``` json 
{ 
    "code": 200, 
    "data": [ 
        { 
            "subUid": "132208121",
            "accountType": "isolated-margin", 
            "activation": "activated" 
        } 
    ] 
} 
| ------ ----- | -------- | -------- | ---- | --------------------- -------------------------------------- | ------------ ---------------- | 
| code | true | int | - | status code | | 
| message | false | string | - | error description (if any) | | 
```

### Response data 

| parameter | required | data type | length | description | value range | 
| data | true | object | | | | 
| {subUid | true | string | - 
| accountType | true | string | - | account type | isolated-margin,cross-margin | | 
activation | true | string | - | account activation status | activated, deactivated |
| errCode | false | int | - | Request rejected error code (returned only when the subUid market access permission error is set) | | | 
errMessage} | false | string | - | Request rejected error message (only returned when the subUid is set Return when the subUid market access permission is wrong) | | 

## Set sub-user asset transfer permission 

API Key permission: transaction 

This interface is used for the parent user to set the sub-user asset transfer permission in batches. 
Sub-user's fund transfer authority includes: 

- Transferring from a sub-user's spot account to another sub-user's spot account under the same parent user; 
- Transferring from a sub-user's spot account to the parent user's spot ( spot) account (no need to set, opened by default). 

###HTTP Request 

- POST `/v2/sub-user/transferability` 

### Request Parameters 

| Parameter | Required | Data Type | Length | Description | Value Range | 
| --------- ---- | -------- | -------- | ---- | ------------------- ----------------------- | ---------- |
| subUids | true | string | - | sub-user UID list (multiple fields are supported, up to 50, separated by commas) | - | | 
accountType | false | string | - | account type (if not filled, the default value is spot) | spot | 
| transferrable | true | bool | - | transferable permission | true,false | 

> Response: 

```json 
{ 
    "code": 200, 
    "data": [ 
        { 
| parameter | required | data type | length | description | value range | 
            "accountType": "spot",
            "transferrable": true, 
            "subUid": 13220823 
        } 
    ] 
} 
``` 

### Response data 

| ------------- | -------- | ---- ---- | ---- | ---------------------------------------- ------------------ | ---------- | 
| code | true | int | - | status code | | 
| message | false | string | - | error description (if any) | | 
| data | true | object | | | | 
| {subUid | true | long | - | sub-user UID | - | 
| accountType | true | string | - | account type | spot | 
| transferrable | true | bool | - |
| errCode | false | int | - | Request rejected error code (returned only when the subUid market access permission error is set) | | | 
errMessage} | false | string | - | Request rejected error message (only returned when the subUid is set Return when the subUid market access authority is wrong) | | 

## Obtain the account list of a specific sub-user 

Through this interface, the parent user can obtain the Account ID list of a specific sub-user and the status of each account 

API Key permission: read 

### HTTP 

request- GET `/v2/sub-user/account-list` 

### request parameter 

| parameter name | required | type | description | default value | range of values ​​| 
| -------- | ---- ---- | ---- | --------- | ------ | -------- | 
| subUid | TRUE | long | sub-user UID | | | 

> Response: 

```json 
{  
    "code": 200,
    "data": { 
        "uid": 132208121, 
        "list": [ 
            {
                "accountType": "isolated-margin",
                "activation": "activated"
            },
            {
                "accountType": "cross-margin",
                "activation": "deactivated"
            },
            {
                "accountType": "spot",
                "activation": "activated",
                "transferrable": true,
                "accountIds": [
                    {
                        "accountId": 12255180,
                        "accountStatus": "normal"
```
}
    }
        ]
            }
                    }
                ]

### Response data 

| Parameter name | Required | Data type | Description | Value range | 
| ----------------- | -------- | - ------- | ------------------------------------------ ------- | ---------------------- | 
| code | TRUE | int | status code | | 
| message | FALSE | string | error description (if any) | | 
| data | TRUE | object | | |  
| { uid | TRUE | long | subuser UID | |
| list | TRUE | object | | | 
| { accountType | TRUE | string | account type | spot, futures, swap | | 
activation | TRUE | string | account activation status | activated, deactivated 
| Transfer permissions (only valid for accountType=spot) | true, false | 
| accountIds | FALSE | object | | | 
| { accountId | TRUE | string | account ID | |
| subType | FALSE | string | account subtype (only valid for accountType=isolated-margin) | | 
| 
accountStatus }}} | TRUE 
| API key for parent user to create sub-user 
### HTTP request 
- POST `/v2/sub-user/api-key-generation` 
### Request parameter 
| parameter name | required | type | description | default value | value range | 
| ----------- | -------- | ------ | ----------------- --------------------------------- | ------ | --------- -------------------------------------------------- -|


 
API Key permission: transaction




| otpToken | true | string | Google verification code of the parent user, the parent user must enable GA secondary verification on the official website page | NA | 6 characters, pure numbers | | permission | true | string | API key permission | NA |  
long | sub-user UID | NA | | 
| API key remarks | NA | Up to 255 characters, unlimited character types |
Value Range: readOnly, trade, where readOnly must be passed, trade is optional, and the two are separated by a half-width comma. | 
| ipAddresses | false | string | The IPv4/IPv6 host address or IPv4 network address bound to the API key | NA | Up to 20 IP addresses, separated by commas, such as: 192.168.1.1,202.106.96.0/ twenty four. If no IP address is bound, the API key is only valid for 90 days. | 

> Response: 

```json 
{ 
    "code": 200, 
    "data": { 
        "accessKey": "2b55df29-vf25treb80-1535713d-8aea2", 
        "secretKey": "c405c550-6fa0583b-fb4bc38e-d317e", 
        "note ": "62924133",
        "ipAddresses": "1.1.1.1,1.1.1.2" 
    } 
} 
``` 


| ------------- | -------- | -------- | ------------------- | -------- | 
| code | true | int | status code | | 
| message | false | string | error description (if any) | | 
| data | true | object | | | 
| { note | true | string | API key note | | 
| accessKey | true | string | access key | | 
| secretKey | true | string | 
| permission | true | string | API key permission | | 
| ipAddresses } | false | string | IP address bound to the API key | |

## Parent-child user API key information query 

This interface is used for the parent user to query its own API key information, and the parent user to query the sub-user's API key information[ 
        {

API Key permission: read 

### HTTP request 

- GET `/v2/user/api-key` 

### request parameter 

| parameter name | required | type | description | default value | value range | 
| --- ------ | -------- | ------ | --------------------------- -------------------------------- | ------ | -------- | 
| uid | true | long | parent user UID, child user UID | NA | | | accessKey | 
false 

| 

```json 
{ 
    "code": 200, 
    "message": "success", 
    "data": [
            "accessKey": "4ba5cdf2-4a92c5da-718ba144-dbuqg6hkte",
            "status": "normal",
            "note": "62924133",
            "permission": "readOnly,trade",
            "ipAddresses": "1.1.1.1,1.1.1.2",
            "validDays": -1,
            "createTime": 1591348751000,
            "updateTime":1591348751000 
| code | true | int | status code | |
| ------------- | ------- - | -------- | ----------------------- | --------------- -------------- |
| parameter name | required | data type | description | value range |
### response data
```
}
    ]
        }


| message | false | string | error description (if any) | | 
| data | true | object | | | | 
[{ accessKey | true | string | access key | | 
| note | true | string | API key note| | 
| permission | true | string | API key permission | | 
| ipAddresses | false | string | IP address bound to the API key | | | 
validDays | true | 
| status | true | string | API key current status | normal (normal), expired (expired) |
| createTime | true | long | API key creation time | | 
| updateTime }] | true | long | API key last modification time | | 

## Modify sub-user API key 

This interface is used by the parent user to modify the sub-user's API key 

API Key Permission: Transaction 

### HTTP Request 

- POST `/v2/sub-user/api-key-modification` 

### Request Parameters 

| Parameter Name | Required | Type | Description | Default Value | Range of Values ​​| 
| - ---------- | -------- | ------ | ----------------------- -- | ------ | ---------------------------------------- -------------------- | 
| subUid | true | long | uid of subuser | NA | |
| accessKey | true | string | access key of sub-user API key | NA | | | 
note | false 
| string | Value range: readOnly, trade, where readOnly must be passed, trade is optional, and the two are separated by a half-width comma. | 
| ipAddresses | false | string | IP address bound to the API key | NA | IPv4/IPv6 host address or IPv4 network address, up to 20 bindings, multiple IP addresses separated by half-width commas, such as: 192.168.1.1,202.106 .96.0/24. If no IP address is bound, the API key is only valid for 90 days. | 

> Response: 

```json 
{ 
    "code": 200, 
    "data": { 
        "note": "test", 
        "permission": "readOnly", 
        "ipAddresses": "1.1.1.3" 
    } 
} 
``` 

### Response data 

| parameter name | Required | Data Type | Description | Value Range | 
| ------------- | -------- | ------- - | ------------------- | -------- | 
| code | true | int | status code | | 
| message | false | string | error description (if any) | | 
| data | true | object | | | 
| { note | false | string | API key note | | | 
permission 
| false | The IP address bound to the key | | 

## Delete sub-user API key 

This interface is used by the parent user to delete the API key of the sub-user 

API Key permission: transaction 

### HTTP request
 
- POST `/v2/sub-user/api-key-deletion` 

### request parameter 

| parameter name | required | type | description | Default value| Range of values|
| --------- | -------- | ------ | -------------------- -- | ------ | -------- | 
| subUid | true | long | uid of sub-user | NA | | 
| accessKey | true | string | access key of API key of sub-user | NA | | 

> Response: 

```json 
{ 
    "code": 200, 
    "data": null 
} 
``` 

### Response data 

| Parameter name | Required | Data type | Description | Value range | 
| --- ----- | -------- | -------- | ---------------- | -------- | 
| code | true | int | Status code | | 
| message | false | string | Error description (if any) | | 

## Asset transfer (between parent and child users) 

API Key permission: transaction<br> 
Frequency limit (NEW ): 2 times/2s 

The parent user executes the transfer between the parent and child users
 
### HTTP Request 

- POST ` /v1/subuser/transfer` 

### Request Parameters 

| Parameters | Required | Data Type | Description | Range of values| 
| -------- | -------- | -------- | ----------------- ----------------------------------------------- | ------ -------------------------------------------------- ---- | 
| sub-uid | true | long | sub-user uid | - | 
| currency | true | v1/common/currency`) | - |
| amount | true | decimal | transfer amount | - | 
| type | true | string | transfer type | Transfer to sub-user virtual currency) | 

> Response: 

```json 
{ 
  "data":123456, 
  "status":"ok" 
} 
``` 

### Response data 

| parameter | required | data type | length | Description| Range of values| 
| ------ | -------- | -------- | ---- | ---------- | -- ------------- | 
| data | true | int | - | transfer order id | - | 
| status | true | | - | status | "OK" or "Error"| 

### error code

| error_code | description | type |
| ----------------------------------------------- | ----- --------------------------- | ------ | 
| account-transfer-balance-insufficient-error | Insufficient account balance| string | 
| base-operation-forbidden | Prohibited operation (parent-child user relationship error reporting) | string | 

## Sub-user deposit address query 

This node is used by the parent user to query sub-user specific currencies (except IOTA) in its block Deposit address in the chain, limited to the parent user 

API Key permission: read 

### HTTP request 

- GET `/v2/sub-user/deposit-address` 

### request parameter 

| field name | required | type | description | default value | range of values ​​| 
| -------- | -------- | ------ | --------- | ----- - | ------------------------------------------------ ------------ |
| subUid | true | long | sub-user UID | NA | limit to 1 | 
| currency | true | string | currency | NA | btc, ltc, bch, eth, etc... /common/currencys`) | 

> Response: 

```json 
{ 
    "code": 200, 
    "data": [ 
        { 
            "currency": "btc", 
            "address": "1PSRjPg53cX7hMRYAXGJnL8mqHtzmQgPUs", 
            "addressTag": "", 
            "chain": "btc"
        } 
    ] 
} 
``` 

### response data 

| field name | required | data type | field description | value range | 
| ---------- | -------- | - ------- | ---------------- | -------- |
| code | true | int | status code | | 
| message | false | string | error description (if any) | | 
| data | true | object | | | 
| { currency | true | string | currency | | | 
address | true | string | deposit address | | 
| addressTag | true | string | deposit address label | | 
| 
chain } | 
true | User recharge records, only available to parent users 
API Key permission: read 
### HTTP request 
- GET `/v2/sub-user/query-deposit` 
### request parameter 
| parameter name | data type | required | description |








| --------- | -------- | -------- | ------------------ -------------------------------- | 
| subUid | long | TRUE | Sub-user UID, only 1 |
The server returns the "nextId" field only if the data entries in the time range requested by the user exceed the single page limit (set by the "limit" field). After the user receives the "nextId" returned by the server –<br>


 
1) You must know that there are still data that cannot be returned on this page;<br> 
2) If you need to continue querying For the next page of data, you should request the query again and use the "nextId" returned by the server as "fromId", and keep other request parameters unchanged. <br> 
3) As the database record ID, "nextId" and "fromId" have no other business meaning except for page turning query. <br> 


> Response: 

```json 
{ 
    "code": 200, 
    "data": [ 
        { 
            "id": 33419472, 
            "currency": "ltc", 
            "chain": "ltc", 
            "amount": 0.001000000000000000 , 
            "address": "LUuuPs5C5Ph3cZz76ZLN1AMLSstqG5PbAz", 
            "state": "safe", 
            "
            "createTime": 1587033225787, 
            "updateTime": 1587033716616 
        } 
    ] 
} 
``` 


| parameter name | required | data type | description | value range | 
| ------------ | --- ----- | ---------- | -------------------------------- --------------------------- | ------------ | 
| code | true | int | status code | 
| message | false | string | error description (if any) | | 
| data | true | object | | | 
long | deposit order id | | 
| currency | true | string | currency | | 
| address | true | string | address | |
| txHash | true | string | transaction hash | | 
| chain | true | string | chain name | | 
| amount | true | 
bigdecimal 
| string | status | see the table below for status | 
| createTime | true | long | launch time | |
| updateTime } | true | long | Last update time | | 
| nextId | false | long | Next page starting number (deposit order ID, this field is included only when query results need to be returned in pages) | | - virtual currency 

recharge Status definition: 

| status | description | 
| ---------- | -------- | 
| unknown | status unknown | 
| 
confirming 
| Completed | 
| orphan | To be confirmed | 

## Sub-user balance (summary) 

API Key permission: read<br> 
Frequency limit value (NEW): 2 times/2s 

The parent user queries the summaries of all sub-users under each currency Balance 

### HTTP Request 

- GET `/v1/subuser/aggregate-balance` 

### Request Parameters 

None 

> Response: 

```json 
{ 
  "status": "ok", 
  "data":[
      {
        "currency": "eos",
        "type": "spot",
        "balance": "1954559.809500000000000000"
      },
      {
        "currency": "btc",
        "type": "spot",
        "balance": "0.000000000000000000"
      },
      {
        "currency": "usdt",
        "type": "spot",
        "balance": "2925209.411300000000000000"
      },
      ...
   ]
}
```

### 响应数据

| ------ | -------- | ----- --- | ---- | ---- | --------------- |
| parameter | required | data type | length | description | value range |
| status | true     |          | -    | 状态 | "OK"or "Error" | 
parameter|required| data type| length| description| value range|
- data
| data | true | list | - | | - |


-----------|------------|-----------|------------| ----------|--|-- 
currency| is | string| -|currency|-|	 
type| is |string| - |account type| spot: spot account | 
balance| is | string | -|Account balance (the sum of available balance and frozen balance)|-| 

## Sub-user balance 

API Key permission: read<br> 
Frequency limit value (NEW): 20 times/2s 

The parent user queries each currency of the sub-user Account Balance 

### HTTP Request 

- GET `/v1/account/accounts/{sub-uid}` 

### Request Parameters 

| Parameter | Required | Data Type | Length | Description | Value Range | 
| --- ---- | -------- | -------- | ---- | ------------ | -------- | 
| sub-uid | true | long | - | UID of the sub-user | - | 

> Response:

```json
{
  "status": "ok",
	"data": [
    {
      "id": 9910049,
      "type": "spot",
      "list": 
      [
        {
          "currency": "btc",
          "type": "trade",
          "balance": "1.00"
        },
        {
          "currency": "eth",
          "type": "trade",
          "balance": "1934.00"
        }
      ]
    },
    {
      "id": 9910050,
      "type": "point", 
### Response data
```
}
	]
    }
      "list": []


id| - | long| - |subuser UID|-|	
-----------|------- ----|----------|------------|----------|--|--
Parameter|Required| Data Type| Length| Description| Value Range| 
type| - |string| - |account type| spot: spot account| list 
| 

- 

|object| Required | data type | length | description | value range | 
| -------- | -------- | -------- | ---- | -- ------ | --------------------------------- | 
| currency | - | string | - | Currency | - | 
| type | - | string | - | account type | trade: trading account, frozen: frozen account | | 
balance | - | decimal | - | account balance 

| 
- 

| 
Provides functions such as placing orders, canceling orders, order inquiries, transaction inquiries, and commission rate inquiries. 

<aside class="notice">Signature authentication is required to access transaction-related interfaces. </aside> 

The following are the return codes and descriptions returned by the transaction-related interfaces.

| Return Code | Description | 
| ------------------------------------------- ----------------- | -------------------------------- ---------------------------- | 
| base-argument-unsupported | A parameter is not supported, please check the parameter | 
| base-system- error | System error, if the order is canceled: the order status cannot be found in the cache, the order cannot be canceled; if the order is placed: the order failed to enter the cache, please try again | | login-required 
| there is no Signature parameter in the url or find Cannot reach this user (the key does not correspond to the account id, etc.) | 
| parameter-required | The stop-loss order lacks the parameter stop-price or operator | 
| base-record-invalid | No data found, please try again later|
| order-amount-over-limit | The order quantity exceeds the limit | 
| base-symbol-trade-disabled | The trading pair is prohibited from trading | 
| base-operation-forbidden | The user is not in the whitelist or the currency does not allow OTC trading Prohibited actions such as| 
| account-get-accounts-inexistent-error | The account does not exist under this user| 
| cancel-disabled | The trading pair is suspended, and the order cannot be canceled| 
| account-account-id-inexistent | The account does not exist|
| order-disabled | The trading pair is suspended, and the order cannot be placed | 
| order-invalid-price | The order price is illegal (for example, the price of the market order cannot have a price, or the price of the limit order exceeds the market price by 10%) | | 
order-accountbalance-error | Insufficient account balance| 
| order-limitorder-price-min-error | The selling price cannot be lower than the specified price| 
| order-limitorder-price-max-error | The buying price cannot be higher than the specified price| 
| order-limitorder- amount-min-error | The order quantity cannot be lower than the specified quantity|
| order-limitorder-amount-max-error | The order quantity cannot be higher than the specified quantity|  
| order-etp-nav-price-min-error | The order price cannot be lower than the specified ratio of the net value|
| order-etp-nav-price-max-error | The order price cannot be higher than the specified ratio such as net value| 
| order-orderprice-precision -error | transaction price precision error | 
| order-orderamount-precision-error | transaction amount precision error | 
| order-value-min-error | order transaction amount cannot be lower than the specified amount | 
| order-marketorder-amount-min-error | The selling quantity cannot be lower than the specified quantity|
| order-marketorder-amount-buy-max-error | The market order buying amount cannot be higher than the specified amount | 
| order-source-invalid | order source is invalid| 
| order-marketorder-amount -sell-max-error | The market order sell quantity cannot be higher than the specified quantity|
| order-holding-limit-failed | The order exceeds the position limit of this currency | 
| order-type-invalid | The order type is invalid | 
| order-orderstate-error | Order status error | 
| order-date-limit-error | The query time cannot exceed the system limit | 
| order-update-error | update data error | 
| order-user-cancel-forbidden | the order type is IOC and cancellation is not allowed|
| order-price-greater-than-limit | The order price is higher than the limit price before the market opening, please place a new order| 
| order-price-less-than-limit | The order price is lower than the limit price before the market opening , please place an order again | 
| order-stop-order-hit-trigger | The stop loss order is triggered by the current price | 
| market-orders-not-support-during-limit-price-trading | Support market order | 
| invalid-interval | query start and end window setting error| 
| price-exceeds-the-protective-price-during-limit-price-trading | The price exceeds the protective price within the price limit|
| invalid-client-order-id | client order id has been repeated | 
| invalid-start-date | query start date contains an invalid value | 
| invalid-end-date | query start date contains an invalid value | 
| invalid- start-time | Query start time contains an invalid value| 
| invalid-end-time | Query start time contains an invalid value| 
| validation-constraints-required | The specified required parameter is missing|
| not-found | The order does not exist when canceling the order | 
| base-not-found | Invalid clientorderid canceled too many orders when canceling the order, try again after an hour | 

## Order 

API Key permission: transaction  
frequency limit value; 100 times/2s

sends a new order to Make a match. 

### HTTP Request 

- POST ` /v1/order/orders/place` 

> Request: 

```json 
{ 
  "account-id": "100009", 
  "amount": "10.1", 
  "price": "100.1" , 
  "source": "api", 
  "symbol": "ethusdt", 
  "type": "buy-limit", 
  "client-order-id": "a0001"

 
| parameter name | data type | required | default value | description | 
| --------------- | -------- | -------- | -------- | -------------------------------- ---------------------------- | 
| account-id | string | true | NA | account ID, value reference `GET /v1 /account/accounts`. Spot transactions use the account-id of the 'spot' account |
| symbol | string | true | NA | trading pair, namely btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) | | 
type | string | true | NA | order type, including buy-market , sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker (see description below), buy-stop-limit, sell-stop-limit | 
| amount | string | true | NA | order transaction volume (market buy order is the order transaction amount) | 
| price | string | false | NA | order price (invalid for market orders) | 
| source | string | false | spot-api | fill in "spot-api" for spot transactions |
| client-order-id | string | false | NA | user-defined order number (maximum length 64 characters, must be unique within 24 hours) | | stop-price | string | false | NA 
| Order trigger price | 
| operator | string | false | NA | Take profit stop loss order trigger price operator gte – greater than and equal (>=), lte – less than and equal (<=) | **buy- 


limit- maker** 

When the "order price" >= "the lowest selling price in the market", the system will reject the order after the order is submitted; 

when the "order price" < "the lowest selling price in the market", after the submission is successful, the The order will be accepted by the system. 

**sell-limit-maker** 

When the "order price" <= "the highest buying price in the market", after the order is submitted, the system will reject the order; 

when the "order price" > "the highest buying price in the market" , the order will be accepted by the system after successful submission. 

> Response: 

```json 
{   
  "data": "59378" 
} 
``` 

### Response Data 

The returned main data object is a string corresponding to the order number.

If the client order ID is reused (within 24 hours), the node will return an error message invalid.client.order.id. 

## Batch order 

API Key permission: transaction<br> 
Frequency limit value (NEW): 50 times/2s<br> 

A batch of up to 10 orders 

### HTTP request


> Request:

```json
[
	{
    "account-id": "123456",
    "price": "7801",
    "amount": "0.001",
    "symbol": "btcusdt",
    "type": "sell-limit",
    "client-order-id": "c1"
	},
	{
    "account-id": "123456",
    "price": "7802",
    "amount": "0.001",
    "symbol": "btcusdt",
    "type": "sell-limit",
    "client-order-id": "d2"
| --------------- | -------- | ---- ---- | -------- | ------------------------------------ ------------------------ |
| parameter name | data type | required | default value | description |
```
]
	}


| [{ account-id | string | true | NA | Account ID, refer to `GET /v1/account/accounts` for value. Spot trading uses the account-id of the 'spot' account; | 
| symbol | string | true | NA | trading pair, ie btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) | | 
type | string | true | NA | order type, including buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker (see below for description) , buy-stop-limit, sell-stop-limit | 
| amount | string | true | NA | order transaction volume (market buy order is the order transaction amount) | |  
| price | string | false | NA | order price (invalid for market orders ) |
source | string | false | spot-api | -api” | 
| client-order-id | string | false | NA | User-made order number (maximum length 64 characters, must be unique within 24 hours) |
| stop-price | string | false | NA | trigger price for stop-loss order | 
| operator }] | string | false | NA | lte – less than and equal (<=) | 

**buy-limit-maker** 

When the "order price" >= "the lowest selling price in the market", the system will refuse to accept the order after the order is submitted 

; "Order Price" < "Minimum Selling Price in the Market", after successful submission, the order will be accepted by the system. 

**sell-limit-maker** 

When the "order price" <= "the highest buying price in the market", after the order is submitted, the system will reject the order; 

when the "order price" > "the highest buying price in the market" , the order will be accepted by the system after successful submission. 

> Response: 

```json 
{ 
            "client-order-id": "c1" 
        }, 
        { 
            " 
    "status": "ok"
    "data": [ 
        { 
            "order-id": 61713400772, 
            "client-order-id": "d2" 
        } 
    ] 
} 
``` 

### response data 

| field name | data type | description | 
| ---- ----------- | -------- | ----------------------------- ------- | 
| [{ order-id | integer | order number | 
| client-order-id | string | user-made order number (if any) | 
| err-code | string | order rejection error code (only valid for rejected orders) | 
| err-msg }] | string | order rejected error message (only valid for rejected orders) | 

If the client order ID (within 24 hours) is reused, the node returns to the previous The order ID and client order ID of the order. 

## Cancel Order 

API Key Permission: Trading<br> 
Frequency Limit (NEW): 100 times/2s

This interface sends a request to cancel an order. 

<aside class="warning">This interface only submits cancellation requests, and the actual cancellation results need to be confirmed through interfaces such as order status and matching status. </aside> 

### HTTP request 

- POST ` /v1/order/orders/{order-id}/submitcancel` 


### Request parameter 

| parameter name | required | type | description | default value | value range | 
| -------- | -------- | ------ | ------------------ | ----- - | -------- | 
| order-id | true | string | order ID, fill in the path | | | 


> Success response: 

```json 
{   
  "data": "59378" 
} 
``` 

### Response data 

The returned main data object is a string corresponding to the order number. 

### Error code 

> Failure response: 

```json 
{ 
  "status": "error", 
  "err-code": " 
  "err-msg": "Order state error", 
  "order-state":


| ----------- | -------------------------------------- ----------------------- | 
| -1 | order was already closed in the long past (order state = canceled, partial-canceled, filled, partial- filled) | 
| 
5 | partial-canceled | 
| 
6 | filled | 
| 7 | canceled | | 
10 
| 100 times/2s 
### HTTP request



This interface sends a request to cancel an order. 

<aside class="warning">This interface only submits cancellation requests, and the actual cancellation results need to be confirmed through interfaces such as order status and matching status. </aside> 


- POST ` /v1/order/orders/submitCancelClientOrder` 

> Request: 

```json 
{ 
  "client-order-id": "a0001" 
} 
``` 

### request parameter 

| parameter name | required | type | description | default value | range of values ​​| 
| --------------- | -------- | ------ | ----- --------- | ------ | -------- | 
| client-order-id | true | string | user-defined order number | | | 


> Response: 

`` `json 
{   
  "data": "10"


 
| Status Code | Description | 
| ----------- | ----------------------------- ----------------------------- | 
| -1 | order was already closed in the long past (order state = canceled, partial- canceled, filled, partial-filled) | 
| 0 | client-order-id not found | 
| 5 | partial-canceled | 
| 6 | filled | 
| 7 | canceled | 
| 
10 
| Key permission: read<br>



Frequency limit value (NEW): 50 times/2s 

to query orders that have been submitted but have not been fully executed or have not been cancelled. 

### HTTP requests

- GET `/v1/order/openOrders` 

> Request: 

```json 
{ 
   "account-id": "100009", 
   "symbol": "ethusdt", 
   "side": "buy" 
} 
``` 

### Request parameter 

| Parameter name | Data type | Required | Default value | Description | 
| ---------- | -------- | ------------ --------------------------------------- | ------ | ------ -------------------------------------------------- ---- | 
| account-id | string | true | NA | Account ID, refer to `GET /v1/account/accounts` for value. Spot transactions use the account-id of the 'spot' account |
| symbol | string | ture | NA | Trading pair, namely btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) | | side |
| side | string | false | both | Specify to only return orders in one direction, possible values ​​are: buy, sell. By default, both directions are returned. | 
| from | string | false | | query starting ID | 
| direct | string | false (if the field 'from' is set, this field 'direct' is required) | | query direction, prev forward; next direction after 
||size|int|false|100| returns the quantity of the order, max 500. | 

> Response: 

```json 
{   
  "data": [ 
      "id": 5454937, 
      "symbol": "ethusdt", 
      "account-id": 30925,
      "price": "0.453000000000000000",
      "created-at": 1530604762277,
      "type": "sell-limit",
      "filled-amount": "0.0",
      "filled-cash-amount": "0.0",
      "filled-fees": "0.0",
      "source": "web",
      "state": "submitted"
| id | integer | order id, no order of size, can be used as the from field of the next page turning query request|
| ------------------ | -------- | - -------------------------------------------------- --------- |
| field name | data type | description |
### response data
```
}
  ]
    }


symbol | string | trading pair, such as btcusdt, ethbtc |
| client-order-id | string | user-made order number (all open orders can return client-order-id) | |
| price | string | transaction price of limit order | 
| created-at | int | timestamp of order creation adjusted to Singapore time, in milliseconds | | 
type | string | order type | 
| filled-amount | string | filled-amount | Amount of filled portion | 
| filled-cash-amount | string | Total price of the filled portion of the order | 
| filled-fees | string | Total amount of transaction fees paid | 
| source | string | fill in "api" for spot transactions |
| state | string | order status, including submitted, partial-filled, canceling, created | 
| stop-price | string | trigger price of stop-profit order | | operator | 
string 
| 
# Batch cancellation of orders (open orders) 

API Key Permission: Transaction<br> 
Frequency limit (NEW): 50 times/2s 

This interface sends requests for batch cancellation of orders. 

<aside class="warning">This interface only submits cancellation requests, and the actual cancellation results need to be confirmed through interfaces such as order status and matching status. </aside> 

### HTTP request 

- POST ` /v1/order/orders/batchCancelOpenOrders` 


### request parameter 

| parameter name | required | type | description | default value | value range |
| ---------- | -------- | ------ | ------------------- ----------------------------------------- | ------ | ---- ------------------------------------------------ |  
| account-id | false | string | Account ID, refer to `GET /v1/account/accounts` | | |
| symbol | false | string | List of transaction symbols (up to 10 symbols, multiple transaction symbols separated by commas), btcusdt, ethbtc... (refer to `/v1/common/symbols` for values) | all | | | side | false 
| string | Active trading direction | | "buy" or "sell", by default all orders that meet the conditions and have not been completed will be returned | | size | false | int | number 
of 
records required to return | 100 | [0,100] 


| 
`json 
{ 
  "status": "ok", 
  "data": { 
    "success-count": 2,
    "failed-count": 0, 
    "next-id": 5454600 
  } 
} 
``` 


### Response data 

 
| parameter name | required | data type | description | value range |
| ------------- | -------- | - ------- | -------------------------- | -------- | 
| success-count | true | int | the number of orders successfully canceled | | 
| failed-count | true | int | the number of orders that failed to be 
canceled | | | next-id | true 

| 

API Key Permission: Transaction<br> 
Frequency Limit (NEW): 50 times/2s 

This interface sends cancellation requests for multiple orders (based on id) at the same time. 

### HTTP Request 

- POST `/v1/order/orders/batchcancel` 

> Request: 

```json 
{ 
  "client-order-ids": [ 
   "5983466", "5722939", " 
} 
``` 

### Request parameter 

| parameter name | required | type | description | default value | value range |
| ---------------- | -------- | -------- | -------------- ------------------------------------------------- | --- --- | ------------------ | 
| order-ids | false | string[] | order ID list (order-ids and client-order-ids must and only You can choose one to fill in, no more than 50 orders) | | No more than 50 orders at a time | 
| client-order-ids | false | string[] | User-made order number list (order-ids and client-order-ids Only one must be selected and filled, no more than 50 orders) | | no more than 50 orders at a time| 

> Response: 

```json 
{ 
    "status": "ok", 
    "data": { 
        "success": [ 
            "5983466"             
        ], 
        "failed": [ 
            { 
              "err-msg": "Incorrect order state", 
              "order-state": 7,
              "order-id": "",
              "err-code": "order-orderstate-error",
              "client-order-id": "first"
            },
            {
              "err-msg": "Incorrect order state",
              "order-state": 7,
              "order-id": "",
              "err-code": "order-orderstate-error",
              "client-order-id": "second"
            },
            {
              "err-msg": "The record is not found.",
              "order-id": "",
              "err-code": "base-not-found",
### Response data
    }
          ]
            }
              "client-order-id": "third"
}
``` 
client-order -id | string | User-made order number (if the user includes client-order-id when creating an order, this field must also be included in the return) |


| Field Name | Data Type | Description | 
| --------- | -------- | --------------------- ------------------------------------------ | 
| { success | string[] | cancel order list of successful orders (can be order-id list or client-order-id list, subject to user request) | 
| failed } | string[] | list of failed orders (can be order-id list or client-order- id list, subject to user request) | 

Cancellation failed order list- 

| field name| data type| description| 
| --------------- | -------- | -------------------------------------------------- ----------- | 
| [{ order-id | string | order number (if the user includes order-id when creating an order, this field must also be included in the return) | | 
err-code | string | Order rejection error code (only valid for rejected orders) | 
| err-msg | string | order rejection error message (only valid for rejected orders) |
| order-state }] | string | current order status (if any) | 

in the returned field list, the possible values ​​of order-state include - 

| order-state | Description | 
| ----------- | -------------------------------------------------- ----------- | 
| -1 | order was already closed in the long past (order state = canceled, partial-canceled, filled, partial-filled) | | 5 | 
partial-canceled |  
| 6 | filled |
| 7 | canceled | 
| 10 | canceling | 

## Query order details 

API Key permission: read<br> 
Frequency limit (NEW): 50 times/2s

This interface returns the latest status and details of the specified order. Orders created through the API cannot be queried after being canceled for more than 2 hours. 

### HTTP request 

- GET `/v1/order/orders/{order-id}` 


### Request parameter 

| parameter name | required | type | description | default value | value range | 
| ----- --- | -------- | ------ | ------------------ | ------ | ---- | 
| order-id | true | string | order ID, fill in path| | | 


> Response: 

```json 
{   
  "data": 
  { 
    "id": 59378, 
    "symbol": "ethusdt" ,  
    "account-id":
    "amount": "10.1000000000", 
    "price": "100.1000000000", 
    "created-at": 1494901162595, 
    "type": "buy-limit", 
    "field-amount":
    "field-fees": "0.0202000000",
    "finished-at": 1494901400468,
    "user-id": 1000,
    "source": "api",
    "state": "filled",
    "canceled-at":0 
| field name | required | data type | description | value range |
### Response data
```
}
  }

 
| -------- --------- | -------- | -------- | ------------------- ----------------------------------------- | ----------- -------------------------------------------------- |
| account-id | true | long | account ID | | 
| amount | true | string | order quantity| | | 
canceled 
-at | false | long | | |
| field-amount | true | string | Transaction amount | | 
| field-cash-amount | true | string | Total transaction amount | | | 
field-fees | true | sold for money) | | 
| finished-at | false | long | the time when the order becomes finalized, not the transaction time, including the status of "cancelled" | | | id | true | 
long | order ID | | 
| client-order-id | false | string | User-made order number (all open orders can return client-order-id (if any); only within 7 days (based on order creation time) closed orders (state <> canceled) can return client-order-id (if any); only closed orders (state = canceled) within 24 hours (based on order creation time) can return client-order-id (such as Yes)) | | 
| price | true | string | order price | | 
| source | true | string | order source | api |
| state | true | string | order status | submitted, partial-filled, partial-canceled, partially canceled, filled, canceled, created | | type | true | string | order type | buy- 
symbol | true | string | trading pair | btcusdt, ethbtc, rcneth ... |
| type | true | string | order type | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc : IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit | | stop-price | 
false | string | stop-loss order trigger price | | | 
operator | false | string | Stop-loss order trigger price operator | gte,lte | 


## Query order details (based on client order ID) 

API Key permission: read<br> 
Frequency limit value (NEW): 50 times/2s 

this interface Return the latest order status and details of the specified user-defined order number (within 24 hours). Orders created through the API cannot be queried after being canceled for more than 2 hours. 

### HTTP requests

- GET `/v1/order/orders/getClientOrder` 

### request parameter 

| parameter name | required | type | description | default value | range of values ​​| 
| ------------- | -------- | ------ | -------------- | ------ | -------- | 
| clientOrderId | true | string | user-defined order number| | | 

> Response: 

```json 
{   
  "data": 
  { 
    "id": 59378, 
    "symbol": "ethusdt", 
    "account-id": 100009, 
    "amount" : "10.1000000000",  
    "price": "100.
    "type": "buy-limit", 
    "field-amount": "10.1000000000", 
    "field-cash-amount": "1011.0100000000", 
    "field-fees":"0.0202000000",
    "finished-at": 1494901400468,
    "user-id": 1000,
    "source": "api", 
    "state": "filled", 
    "canceled-at": 0 
  } 
} 
``` 

### response data 

| field name | required | data type | description | value range | 
| canceled-at | false | long | order cancellation time | |
| account-id | true | long | account ID | |
| ----------------- | ---- ---- | -------- | ------------------------------------ ------------------------ | ------------------------- ----------------------------------- |
| amount | true | string | order quantity | |
| created-at | true | long | order creation time | | 
| field-amount | true | string | transaction amount                                                    | | 
| field-cash-amount | true 
| true | string | transaction fee (buying is currency, selling is money) | |
| finished-at | false | long | The time when the order becomes finalized, not the transaction time, including the status of "cancelled" | | | id | true | 
long | order ID | | | 
| state | true | string | order status | submitted, partial-filled, partial-canceled, partially canceled, filled, canceled, created | 
order ID | | | ) | | 
| price | true | string | order price | |
string | order source | api | 
| type | true | string | order type | market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop -limit, sell-stop-limit | 
| stop-price | false | string | trigger price of stop loss order | |
| symbol | true | string | trading 
pair 
| btcusdt, ethbtc, rcneth ... | | 
Information 
{ 
    "status": "error", 
    "err-code": "base-record-invalid", 
    "err-msg": "record invalid", 
    "data": null 
} 

## transaction details 

API Key permissions: read Fetching<br> 
Frequency limit value (NEW): 50 times/2s 

This interface returns the transaction details of the specified order. 

### HTTP request 

- GET `/v1/order/orders/{order-id}/matchresults` 

### Request parameters

| Parameter   
name | Required | Type | Description | Default value | Range of values ​​| 
| 
order  
| --- ----- | -------- | ------ | ------------------ | ------ | -- ------ |
-id | true | string 
  | 
    { 
      "id": 29553, 
      "order-id": 59378, 
      "match-id": 59335, 
      "trade-id": 100282808529, 
      "symbol": "ethusdt", 
      "type": "buy-limit", 
      " source": "api", 
      "price": "100.1000000000", 
      "filled-amount": "9.1155000000", 
      "filled-fees": "0.0182310000", 
      "created-at":1494901400435,
      "role": "maker",
      "filled-points": "0.0",
      "fee-deduct-currency": ""



    } 
    ... 
  ] 
} 

### Response data
```

<aside class="notice">The returned main data object is an array of objects, each of which represents a transaction result. </aside> 

| field name | required | data type | description | value range | 
| ------------------- | -------- | -------- | ----------------------------------------- ------------------- | --------------------------- ------------------------------ | 
| created-at | true | long | transaction time stamp timestamp | | 
| filled-amount | true | string 
| | string | Transaction fee (positive value) or transaction rebate (negative value) | | 
fee-currency | true | string | Fee or transaction rebate currency (the transaction fee currency for buy orders is the base currency, the transaction fee currency for sell orders is the pricing currency; the transaction commission currency for buy orders is the pricing currency, and the transaction commission currency for sell orders type is the base currency) | | 
| id | true | long | order transaction record ID | | 
match-id | 
true | long | Order ID, the ID of the order to which the transaction belongs | | 
| trade-id | false | integer | Unique trade ID (NEW) Unique trade ID, the unique ID generated when the transaction is made |
string | transaction price| | 
| source | true | string | order source| api |  
| string | trading pair | btcusdt, ethbtc, rcneth ... |
| type | true | string | order type| : buy limit, sell-limit: sell limit, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit | 
role | true | string | transaction role | maker, taker |
| filled-points | true | string | deductible amount (can be ht or hbpoint) | | 
| fee-deduct-currency | true | The fee is deducted from the deductible asset | 
| fee 
- 
deduct-state | true | string | The commission amount may not be credited in real time. <br> 
## Search historical orders 
API Key Permission: Read<br> 
Frequency limit (NEW): 50 times/2s 
This interface queries historical orders based on search conditions. Orders created through the API cannot be queried after being canceled for more than 2 hours. 
Users can choose to query historical orders by "time range" instead of the original query method of "date range".







- If the user fills in start-time AND/OR end-time to query historical orders, the server will query and return according to the "time range" specified by the user, and ignore the start-date/end-date parameters. The query window size of this method is limited to a maximum of 48 hours, and the window translation range is the last 180 days. 

- If the user does not fill in the start-time/end-time parameters, but fills in start-date AND/OR end-date to query historical orders, the server will query and return according to the "date range" specified by the user. The query window size of this method is limited to a maximum of 2 days, and the window translation range is the last 180 days. 

- If the user neither fills in the start-time/end-time parameter nor the start-date/end-date parameter, the server will default to the current time as the end-time and return the historical orders within the last 48 hours. 

It is recommended that users query historical orders by "time range". 


### HTTP Request 

- GET `/v1/order/orders` 

> Request: 

```json 
{ 
   "account-id": "100009", 
   "amount": "10.1", 
   "price": "100.1", 
   " source": "
   "type": "buy-limit" 
} 
```

 
### request parameter

| Parameter name | Required | Type | Description | Default value | Value range | 
| ---------- | -------- | ------ | ---- -------------------------------------------------- ------ | --------------------------- | --------------- ------------------------------------------------ | 
| symbol | true | string | Trading pair | | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |
| types | false | string | Combinations of order types to query, separated by commas | | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy- ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit | | start-time | false | long | query start time, 
time Format UTC time in milliseconds. Query based on order generation time | -48h 48 hours before the query end time | Value range [((end-time) – 48h), (end-time)], the maximum query window is 48 hours, and the window translation range is the nearest 180 days, the translation range of the query window for historical orders that have been completely canceled is only the last 2 hours (state="canceled") | | 
end-time | false | long | query end time, time format UTC time in millisecond. Query based on order generation time | present | value range [(present-179d), present], the maximum query window is 48 hours, the window translation range is the last 180 days, and the query window translation range of completely canceled historical orders is only the latest 2 hours (state="canceled") |
| start-date | false | string | query start date, date format yyyy-mm-dd. Query based on the order generation time | -1d 1 day before the query end date | Value range [((end-date) – 1), (end-date)], the maximum query window is 2 days, and the window translation range is the nearest 180 days, the translation range of the query window for historical orders that have been completely canceled is only the last 2 hours (state="canceled") | | 
end-date | false | string | query end date, date format yyyy-mm-dd. Query based on order generation time | today | value range [(today-179), today], the maximum query window is 2 days, the window translation range is the last 180 days, and the query window translation range of completely canceled historical orders is only the latest 2 hours (state="canceled") | 
| states | true | string | query order status combination, use ',' to split| | submitted submitted, partial-filled partial transaction, partial-canceled partial transaction canceled, filled complete transaction ,
| direct | false | string | query direction | | prev forward; next backward | 
| size | false | string | query record size | 100 | [1, 100] |,
      "field-amount": "10.1000000000",

 
>

```json
{  
  "data": [
    {
      "id": 59378,
      "symbol": "ethusdt",
      "account-id": 100009,
      "amount": "10.1000000000",
      "price": "100.1000000000",
      "created-at": 1494901162595,
      "type": "buy-limit",
      "field-cash-amount": "1011.0100000000",
      "field-fees": "0.0202000000",
      "finished-at": 1494901400468,
      "user-id": 1000,
      "source": "api",
      "state": "filled",
      "canceled-at": 0 
### Response data
```
}
  ]
    ...
    }

 
| parameter name | required | data type | description | value range | 
| ------------- ---- | -------- | -------- | ------------------------ ------------------------------------ | ---------------- ----------------------------------------------- | 
ID | | 
| amount | true | string | order quantity | 
|
| created-at | true | long | order creation time | |
| field-amount | true | string | completed transaction quantity | |  
field-cash-amount | true 
| true | string | transaction fee (buying is base currency, selling is price currency) | |
| finished-at | false | long | last transaction time | | 
| id | true | long | The from field of | | 
| client-order-id | false | string | User-created order number (all open orders can return client-order-id (if any); only closed orders within 7 days (based on order creation time) ( state <> canceled) can return client-order-id (if any); only closed orders (state = canceled) within 24 hours (based on order creation time) can be queried) | |
| price | true  
| source | true | string | order source | api |
| string | order price | | 
| | true | string | trading pair | btcusdt, ethbtc, rcneth ... | 
cancel : Order cancellation application has been submitted, buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc: IOC sell order , buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit | | 
stop-price | false | string | trigger price of stop-loss order | | 
| operator | false | string | Stop-loss order trigger price operator | gte, lte |

### start-date, end-date related error code 

| error code | corresponding error scene | 
| ------------------ | --------- -------------------------------------------------- - | 
   " 
| invalid_interval | start date is less than end date; or the time interval between start date and end date is greater than 2 days|
| invalid_start_date | start date is a date 180 days ago; or start date is a date in the future | 
| invalid_end_date | end date is a date 180 days ago; or end date is a date in the future | 

## Search for the last 48 hours API Key permissions for historical orders within 

: Read<br> 
Frequency limit (NEW): 20 times/2s 

This interface queries historical orders within the last 48 hours based on search criteria. Orders created through the API cannot be queried after being canceled for more than 2 hours. 

### HTTP Request 

- GET `/v1/order/history` 

> Request: 

```json 
{ 
   "symbol": "btcusdt", 
   "start-time": "1556417645419", 
   "end-time": "1556533539282" , 
} 
``` 

### request parameter 

| parameter name | required | type | description | default value | value range |
| ---------- | -------- | ------ | ------------------- ----------------------------------------- | ----------- --- | ---------------------------------------------- -------- | 
| symbol | false | string | trading pair | all | btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for value) | 
| | query start time (inclusive) | time 48 hours ago | UTC time in millisecond | 
| end-time | false | long | query end time (inclusive) | query time | UTC time in millisecond |
| direct | false | string | order query direction (Note: it only works when the total number of retrieved items exceeds the limit of the size field; if the total number of retrieved items is within the limit of the size field, the direct field does not work.) | next | prev forward, next backward | 
| size | false | int | number of items returned each time | 100 | [10,1000] | 

> Response: 

```json 
{ 
    "status": "ok", 
    "data" : [ 
        { 
            "id": 31215214553, 
            "symbol": "btcusdt", 
            "account-id": 4717043, 
            "amount": "1.000000000000000000",  
            "price": "1.000000000000000000",
            "created-at": 1556533539282,
            "type": "buy-limit",
            "field-amount": "0.0",
            "field-cash-amount": "0.0",
            "field-fees": "0.0", 
            "finished-at": 1556533568953, 
            "source": "web", 
            "state": "canceled", 
            "canceled-at": 1556533568911 
        } 
    ] 
} 
``` 

### Response data
 
| Parameter name | Required | Data type | Description | Value range | 
| ----------------- | --- ----- | -------- | ----------------------------------- ------------------------- | ------------------------ --------------------------------------- |
| {account-id | true | long | account 
ID | | 
| amount | true | string | order quantity | 
| long | order creation time | | 
| field-amount | true | string | Transaction amount | | 
| field-cash-amount | true 
| field-fees | true | string | transaction fee (buying is base currency, selling is price currency) | | 
| finished-at | false | long | Last transaction time | 
| long | order ID, no order of size | |
| client-order-id | false | string | user-defined order number (only closed orders (state <> canceled) within 48 hours (based on order creation time) can return client-order-id (if any); only 24 Closed orders (state = canceled) within hours (based on order creation time) can be queried) | | | 
price | true | string | order price | |  
| true | string | order source | api |
| state | true | string | order status | filled Completely traded, canceled Canceled | 
| symbol | true | string | trading pair | btcusdt, ethbtc, rcneth ... |
| stop-price | false | string | stop-loss order trigger price | | 
| operator | false | string | stop-loss order trigger price operator | gte,lte | 
### Request parameters 
| type} | true | string | order type | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit : Sell limit, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-limit-maker, sell-limit-maker |
| next-time | false | long | Next query start time (valid when the request field "direct" is "prev"), next query end time (valid when the request field "direct" is "next"). Note: This return field exists only when the total number of items retrieved exceeds the limit of the size field. | UTC time in millisecond | 


## Current and historical transactions 

API Key Permission: Read<br> 
Frequency limit value (NEW): 20 times/2s 

This interface queries current and historical transaction records based on search conditions. 

### HTTP request 

- GET `/v1/order/matchresults` 
| ---------- | ----- --- | ------ | --------------------------------------- ------- | ----------------------- | ------------------ --------------------------------------------- |



| Parameter name | Required | Type | Description | Default value | Range of values ​​| 
| symbol | true | string | Trading pair | N/A | `) | 
| types | false | string | Combination of order types to query, use ',' to split | all | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: Sell ​​limit, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit | | start-date | false | 
string | Query start date (Singapore time zone) date format yyyy-mm-dd | -1d 1 day before the query end date | Value range [((end-date) – 1), (end-date)], the query window is the largest is 2 days, and the window translation range is the last 61 days. | 
false | string | query end date (Singapore time zone ), date format yyyy-mm-dd | today | value range [(today-60), today], the maximum query window is 2 days, and the window translation range is the last 61 days | | from | false | string | query 
start ID | N/A | If it is a backward query, it will be assigned the last id (not trade-id) obtained in the previous query result; if it is a forward query, it will be assigned the first one obtained in the previous query result bar id (not trade-id) | 
| direct | false | string | query direction | next | prev forward; next backward | 
false | string | query record size | 100 | [1, 500] | 

> Response: 

```json 
{   
  "data": [ 
    { 
      "id": 29553, 
      "order-id": 59378, 
      "match-id": 59335, 
      "symbol": "ethusdt", 
      "type": "buy-limit",
      "source": "api", 
      "price": "100.1000000000", 
      "filled-amount": "9.1155000000", 
      "filled-fees": "0.0182310000", 
      "created-at": 1494901400435, 
      "trade-id": 100282808529, 
      "role": taker, 
      "filled-points": "0.0", 
      "fee-deduct-currency": "" } ` 
| parameter name | required | data type | description | value range |
    }
    ...
  ]
} 
``` 

### Response data 

<aside class="notice"> The returned main data object is an array of objects, each of which represents a transaction result. </aside>

| ------------------- | -------- | -------- | ----------- -------------------------------------------------- | -------------------------------------------------- ---------- | 
| created-at | true | long | transaction timestamp timestamp | | 
| filled-amount 
| true | string | Fee (positive value) or transaction rebate (negative value) | |
| fee-currency | true | string | transaction fee or transaction rebate currency (the transaction fee currency for buy orders is the base currency, the transaction fee currency for sell orders is the pricing currency; the transaction rebate currency for buy orders is the pricing currency, and the transaction rebate currency of the sell order is the base currency) | | 
| id | true | long | order transaction record ID, no order of size, can be used as the from field of the next page turning query request | | | 
match -id | true | long | matching ID | |  
| order-id | true | long | order ID | |
| trade-id | false | integer |
string | transaction price| | 
| source | true | string | order source| api |  
| symbol | true | , rcneth ... |
| type | true | string | order type| : buy limit, sell-limit: sell limit, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit | 
role | true | string | transaction role | maker, taker |
| filled-points | true | string | deduction amount (can be ht or hbpoint) | | 
| fee-deduct-currency | true | string | deduction type | | 
| fee-deduct-state | true | string | deduction Status | Deduction in progress: ongoing, deduction completed: done | 

Note: <br> 

- The transaction rebate amount in filled-fees may not be credited in real time; <br> 

### start-date, end-date related Error code 

| Error code | Corresponding error scene | 
| ------------------ | -------------------- ------------------------------------------- | 
| invalid_interval | start date is less than end date; or between start date and end date The time interval is greater than 2 days | 
| invalid_start_date | start date is a date 61 days ago; or start date is a date in the future | 
| invalid_end_date | end date is a date 61 days ago; or end date is a date in the future | 


## Obtain the user's current transaction fee rate 

Api user queries the transaction pair fee rate, a maximum of 10 transaction pairs can be checked at a time, and the sub-user's fee rate is consistent with the parent user 

API Key permission: read 

```shell 
curl "https: //api.bitv.com/v2/reference/transact-fee-rate?symbols=btcusdt,ethusdt,ltcusdt" 
``` 

### HTTP Request 

- GET `/v2/reference/transact-fee-rate` 

## # Request parameter 

| parameter | data type | required | default value | description | value range |
| ------- | -------- | -------- | ------ | ---------------- -------- | ----------------------------------------- -------------- | 
| symbols | string | true | NA | Trading pairs, multiple entries are allowed, separated by commas | btcusdt, ethbtc... (value reference `GET /v1/common /symbols`)> | 

> Response: 

```json 
{ 
  "code": "200", 
  "data": [ 
     { 
        "symbol": "btcusdt", 
        "makerFeeRate":"0.002", 
        "takerFeeRate":"0.002 ", 
        "actualMakerRate": "0.002", 
        "actualTakerRate": "0.002 
     }, 
     { 
        "symbol": "ethusdt", 
        "makerFeeRate":"0.002",
        "takerFeeRate":"0.002",
        "actualMakerRate": "0.002",
        "actualTakerRate":"0.002 
| data | object | |actualTakerRate":"0.002
    },
     {
        "symbol": "ltcusdt",
        "makerFeeRate":"0.002",
        "takerFeeRate":"0.002",
        "actualMakerRate": "0.002",
        "actualTakerRate":"0.002 
| makerFeeRate | , if the transaction fee rebate is applicable, return the rebate rate (negative value) |
| { symbol | string | transaction code |
| message | string | error description (if any) |
| code | integer | status code |
| ----------------- | -------- | - -------------------------------------------------- --------- |
| field name | data type | description |
### response data
```
}
  ]
    }


| takerFeeRate | string | basic fee rate - active party | 
| actualMakerRate | string | post-deduction fee rate - passive party, if the deduction is not applicable or deduction is not enabled, the basic fee rate will be returned; if the transaction fee rebate is applicable, Return rebate rate (negative value) | 
| actualTakerRate } | string | After deduction rate – the active party, if the deduction is not applicable or deduction is not enabled, return the basic rate | 

Note: <br> 

- such as makerFeeRate/ If actualMakerRate is a positive value, this field means the transaction fee rate;<br> 
- If makerFeeRate/actualMakerRate is a negative value, this field means the transaction rebate rate. <br> 


# Websocket Market Data 

## Introduction 

### Access URL 

**Quote Request Address** 

**`wss://api.bitv.com/ws`**   

### Data Compression 
 
returned by WebSocket market interface All data is compressed by GZIP, and the client needs to decompress it after receiving the data.

### Heartbeat Message 

```json 
{"ping": 1492420473027} 
``` 

When the user's Websocket client connects to the Websocket server, the server will periodically (currently set to 5 seconds) send a `ping` message to it and include an integer value. 

```json 
{"pong": 1492420473027} 
```

When the user's Websocket client receives this heartbeat message, it should return a `pong` message containing the same integer value. 

<aside class="warning">When the Websocket server sends `ping` messages twice but does not receive any `pong` messages back, the server will actively disconnect from the client. </aside> 

### Subscribe to the topic 

> Sub request: 

```json 
{ 
  "sub": "market.btcusdt.kline.1min", 
  "id": "id1" 
} 
``` 

Successfully establish a connection with the Websocket server After that, the Websocket client sends a request to subscribe to a specific topic: 

{ 
  "sub": "topic to sub", 
  "id": "id generate by client" 
} 

> Sub response: 

```json
  "id": "id1", 
  "status": "ok", 
  "subbed": "market.btcusdt.kline.1min", 
  "ts": 1489474081631 
}


After that, once the subscribed topic is updated, the Websocket client will receive the update message (push) pushed by the server. 

### Unsubscribe 

> UnSub request: 

```json 
{ 
  "unsub": "market.btcusdt.trade.detail", 
  "id": "id4" 
} 
``` 

The format of unsubscribe is as follows: 

{ 
  "unsub": "topic to unsub", 
  "id": "id generate by client" 
} 

> UnSub response: 

```json 
{ 
  "id": "id4", 
  "status": "ok", 
  "unsubbed": "market.btcusdt .trade.detail", 
  "ts": 
1494326028889 } 
``` 

Unsubscribe successfully confirmed. 

### Request data 

The Websocket server also supports one-time request data (pull). 

The format of a one-time request is as follows: 

{ 
  "req": "topic to req", 
  "id": "id generate by client" 
} 

For the specific format of the one-time returned data, refer to each topic. 

### Frequency limit 

Data request (req) frequency limit rule 

Every two requests for a single connection cannot be less than 100ms. 

### Error codes 

The following are the error codes, error messages and descriptions of the WebSocket market interface. 

| Error code | Error message | Description | 
| ----------- | ---------------------------- ---------- | ------------------------ | 
| bad-request | invalid topic | topic error | 
| bad- request | invalid symbol | symbol error | 
| bad-request | symbol trade not open now |
| bad-request | 429 too many request | req Request too frequently | 
| bad-request | unsub with not subbed topic | Not subscribed to this topic |
| bad-request | not json string | The request sent is not in JSON format | 
| 
1008 | header required correct cloud-exchange | exchangeCode parameter error | 
| 
bad-request | request timeout | Subscription 
Once the K-line data is generated, the Websocket server will push it to the client through this subscription topic interface: 
`market.$symbol$.kline.$period$` 
> subscription request```json 
{ 
" 
  sub": "market.ethbtc. kline.1min", 
  "id": "id1" 
} 
``` 
### parameter 
| ------ | ------- - | -------- | -------- | --------------------------- --------------------------------- |








| parameter | data type | required | description | value range | 
| symbol | string | true | transaction code | btcusdt, ethbtc...etc 
. | 30min, 60min, 4hour, 1day, 1mon, 1week, 1year | 

> Response 

```json 
{ 
  "id": "id1", 
  "status": "ok", 
  "subbed": "market.ethbtc.kline.1min" , 
  "ts": 1489474081631 //system response time 
} 
``` 

> Update example 

```json 
{ 
  "ch": "market.ethbtc.kline.1min", 
  "ts": 1489474082831,//system update time
  "tick": {
    "id": 1489464480,
    "amount": 0.0, 
| high | float | highest price|
    "count": 0,
    "open": 7962.62,
    "close": 7962.62,
    "low": 7962.62,
    "high": 7962.62, 
    "vol": 0.0 
  } 
} 
``` 

### data update field list 

| field | data type | description | 
| ------ | -------- | -- ----------------------------------------- | 
| id | integer | unix time, At the same time as K-line ID | 
| amount | float | volume | 
| count | integer | number of transactions | 
| open | float | opening price | 
| close | float | is the latest transaction price) | 
| low | float | lowest price | | 
vol 
|


 
The following additional parameters need to be provided to obtain K-line data at one time by request method: 
(maximum return 300 each time Article) 

```json 
{ 
  "req": "market.$symbol.kline.$period", 
  "id": "id generated by client", 
  "from": "from time in epoch seconds", 
  "to": "to time in epoch seconds" 
} 
``` 

| parameter | data type | required | default value | description | range of values ​​| 
| ---- | -------- | ----- --- | ---------------------------------------- | -------- ----------------------- | -------------------------- ------------------------------------- | 
| from | integer | false | 1501174800(2017-07-28T00:00:00+08:00) | start time (epoch time in second) | [1501174800, 2556115200] | | to | integer | false | 2556115200 
( 2050-01-01T00:00:00+08:00) | End time (epoch time in second) | [1501174800,2556115200] or ($from, 2556115200] if "from" is set |

## Depth of Market Data 

This topic sends the latest Depth of Market snapshot. The snapshot frequency is 1 time per second. 

### Topic subscription 

`market.$symbol.depth.$type` 

> Subscribe request 

```json 
{ 
  "sub": "market.btcusdt.depth.step0", 
  "id": "id1" 
} 
``` 

# ## parameter
 
| parameter | data type | required | default value | description | range of values ​​| 
| ------ | -------- | -------- | -- ---- | ------------ | -------------------------------- ---------------------- | 
| symbol | string | true | NA | transaction symbol | btcusdt, ethbtc...
| type | string | true | step0 | merge depth type | step0, step1, step2, step3, step4, step5 | **" 

type" merge depth type** 

| Value | Description | 
| ----- | --- --------------------------------- | 
| step0 | Do not merge depth | 
| step1 | Aggregation level = precision*10 | 
| step4 | Aggregation level = precision*10000 | 
| step5 | Aggregation level = precision*100000 | 

When the type value is 'step0', the default depth is 150; 
when the type value is 'step1','step2','step3 ','step4','step5', the default depth is 20 files. 

> Response 

```json 
{ 
  "id": "id1", 
  "status": "ok", 
  "subbed": "market.btcusdt.depth.step0", 
  "ts": 1489474081631 //system response time 
} 
``` 

> Update example 

```json 
{ 
  "ch": " market.htusdt.depth.step0", 
  "ts": 1572362902027, //system update time 
  "tick": { 
    "bids": [ 
      [3.7721, 344.86], // [price, size] 
      [3.7709, 46.66] 
    ], 
      [3.7746, 70.52] 
    ], 
    "version": 100434317651 , 
    "ts": 1572362902012 //quote time 
  } 
} 
``` 

### Data update field list 

<aside class="notice">The depth list of buying and selling orders is presented under the 'tick' object</aside> 

| field | data type | description | 
| ------- | ------- - | ---------------------------- | 
| bids | object | current all buy orders [price, size] | 
| asks | object | all current sell orders [price, size] | 
| version | integer | internal field | | ts | integer | timestamp of Singapore time, 
in 
milliseconds | 
，amount, count, vol are all zero values</aside> 

### Data request 

Support data request method to obtain market depth data at one time: 

```json 
{ 
  "req": "market.btcusdt.depth.step0", 
  " id": "id10"
} 
``` 

## Market depth MBP market data (incremental push)

Users can subscribe to this channel to receive the incremental data push of the latest in-depth market Market By Price (MBP); at the same time, this channel supports users to request full data in the form of req. 

**MBP incremental push and MBP full REQ request address** 

**`wss://api.bitv.com/feed`**Suggested   

downstream data processing methods:<br> 
2) Request full data (equal number of stalls ) and align the seqNum of the full message with the prevSeqNum in the cached incremental data;<br> 
3) Start continuous incremental data reception and calculation, build and continuously update the MBP order book;<br> 
4) Each piece of incremental data The prevSeqNum of the previous incremental data must be consistent with the seqNum of the previous incremental data, otherwise it means that the incremental data is lost, and the full amount of data must be reacquired and aligned;<br> 5) 
If the incremental data received contains the new price gear, it must be The price level is inserted into the appropriate position in the MBP order book;<br> 
6) If the received incremental data contains the existing price level, but the size is different, the size of the price level in the MBP order book must be replaced;<br> 
7) If the size of a certain price gear in the incremental data is 0, the price gear must be deleted from the MBP order book;<br> 
8) If a single incremental data contains two or more prices The update of the stalls, these price stalls must be updated in the MBP order book at the same time. <br> 

Currently only supports the push of 5-file/20-file MBP step-by-step increments and 150-file MBP snapshot increments. The difference between the two is-<br> 
1) The depth is different;<br> 
2) 5 files/20 files Incremental MBP market price by tick, 150 files are 100 millisecond timed snapshot incremental MBP market price;<
3) When only unilateral market changes occur in the 5-level/20-level order book, the incremental push only includes unilateral market updates. For example, the push message contains the array of asks, but not the array of bids;<br> ``` 

json 
{ 
    "ch": "market.btcusdt.mbp.5", 
    "ts": 1573199608679, 
    "tick": { 
        "prevSeqNum": 100020146794, 
        "asks": [ 
            [645.140000000000000000, 26.755973959140651643 ] 
        ] 
    } 
} 
``` 

When 150 When only unilateral market changes occur in the order book, the incremental push includes bilateral market updates, but one side of the market is empty. For example, the push message contains the update of the array asks and also includes the empty array of bids;<br> `` 

` json 
{ 
    "ch":"market.btcusdt.mbp.150", 
    "ts":1573199608679, 
    "tick":{ 
        "seqNum":100020146795, 
        "prevSeqNum":100020146794,
        "bids":[ ],
        "asks":[eosusdt, ltcusdt, etcusdt, adausdt, dashusdt, bsvusdt), 150 snapshot increments support all trading pairs. <br>

 
```json

 
The REQ channel supports the acquisition of full data of 5 files/20 files/150 files. <br> 

### Subscribe incremental push 

`market.$symbol.mbp.$levels` 

> Sub request 

```json 
{ 
  "sub": "market.btcusdt.mbp.5", 
  "id": "id1"




  "req": "market.btcusdt.mbp.5", 
  "id": "id2" 
} 
``` 

### parameter 

| parameter | data type | required | default value | description | value range | 
| levels | integer | true | NA | depth level (value: 5, 20, 150) | currently only supports 5 levels, 20 levels, or 150 levels of depth | > Response (incremental subscription) ```json 

{ 

" 
id 
  " : "id1", 
  "status": "ok", 
  "subbed": "market.btcusdt.mbp.5", 
  "ts": 1489474081631 //system response time 
} 
``` 

> Incremental Update (incremental subscription) 

` ``json 
{ 
	"ch": "market.btcusdt.mbp.5", 
	"ts": 1573199608679,//system update time
  "tick": {
           "seqNum": 100020146795,
            "prevSeqNum": 100020146794,
           "asks": [
                 [645.140000000000000000, 26.755973959140651643] // [price, size]
           ]
      }
}
```
 
> Response (full request)

```json
{
	"id": "id2",
	"rep": "market.btcusdt.mbp.150",
	"status": "ok",
	"data": {
		"seqNum": 100020142010,
		"bids": [
			[618.37, 71.594], // [price, size]
			[423.33, 77.726],
			[223.18, 47.997],
			[219.34, 24.82],
			[210.34, 94.463]
    ],
		"asks": [
			[650.59, 14.909733438479636],
			[650.77, 97.465],
			[650.63, 97.996],
			[651.23, 83.973], 
			[651.42, 34.465] 
		] 
	} 
} 
``` 

### data update field list 

| ---------- | -------- | ------ ------------------------------------ |
| field | data type | description |
| seqNum | integer | message sequence number | 
| prevSeqNum | integer | previous message sequence number | 
| bids | object | buy Offers, sorted by price in descending order, ["price","size"] | 
| asks | object | Sell orders, sorted by price in ascending order, ["price","size"] | 

## Market depth MBP market data (full volume push ）

Users can subscribe to this channel to receive the full data push of the latest market by Market By Price (MBP). The push frequency is about once every 100 milliseconds. 

### Subscribe incremental push 

`market.$symbol.mbp.refresh.$levels` 

> Sub request 

```json 
{ 
"sub": "market.btcusdt.mbp.refresh.20", 
"id": "id1 "


| parameter | data type | required | default value | description | value range |
			[423.33, 77.726],
| symbol | string | true | NA | transaction code (wildcards not supported) | | 
| levels | integer | true | NA | depth level | 5,10,20 | 

> Response 

```json 
{ 
"id": "id1 ", 
"status": "ok", 
"subbed": "market.btcusdt.mbp.refresh.20", 
"ts": 1489474081631 //system response time 
} 
``` 

> Refresh Update 

```json 
{ 
"ch ": "market.btcusdt.mbp.refresh.20", 
"ts": 1573199608679, //system update time 
"tick": { 

		"seqNum": 100020142010, 
		"bids": [ 
			[618.37, 71.594], // [ price,size] 
			[223.18, 47.997], 
			[219.34, 24.82], 
			[210.34, 94.463], ... // omit the remaining 15 files
   		], 
		"asks": [ 
			[650.59, 14.909733438479636], 
			[650.63, 97.996], 
			[650.77, 97.465], [ 
			651.23, 83.973], 
			[651.42, 34.465], ... // omit the remaining 15 files 
		] 
} 
} 
` `` 

### Data update field list 

| field | data type | description | 
| ------ | -------- | ---------------- ----------------------- | 
| seqNum | integer | message sequence number | 
| bids | object | buy orders, sorted by price in descending order, ["price" ,"size"] | 
| asks | object | Sell orders, arranged in ascending order of price, ["price","size" 


] 

| , Sell a quantity, when any of the data changes, this topic will be updated one by one. 

### Topic subscription to 

`market.$symbol.bbo` 

>

```json 
{ 
  "sub": "market.btcusdt.bbo", 
  "id": "id1" 
} 
``` 

### parameter 

| parameter | data type | required | default value | description | value range | 
| ------ | -------- | -------- | ------ | -------- | ------- -------------------------------------------------- | 
| symbol | string | true | NA | transaction symbol | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) | > Response ``` 

json 

{ 
" 
  id": "id1", 
  "status": "ok", 
  "subbed": "market.btcusdt.bbo", 
  "ts": 1489474081631 //system response time 
} 
``` 

>Update example

```json
{
  "ch": "market.btcusdt.bbo",
  "ts": 1489474082831, //system update time
  "tick": {
    "symbol": "btcusdt",
    "quoteTime": "1489474082811",
    "bid": "10008.31",
    "bidSize": "0.01",
    "ask": "10009.54",
    "askSize": "0.3",
    "seqId":"10242474683"
|
|
| bid
| quoteTime | long | order update time |
| symbol | string | transaction code |
| --------- | -------- | ---------- -- |
| field | data type | description |
### Data update field list
```
}
  }


### topic subscription
## transaction details
| | int | message serial number |
| bidSize




This topic provides a tick-by-tick breakdown of the latest transactions in the market. 

`market.$symbol.trade.detail` 

> Subscribe request 

```json 
{ 
  "sub": "market.btcusdt.trade.detail", 
  "id": "id1" 
} 
``` 

### parameter 

| parameter| Data type | Required | Default value | Description | Range of values ​​| 
| ------ | -------- | -------- | ------ | - ------- | ------------------------------------------ ------------ | 
| symbol | string | true | NA | transaction symbol | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) | > Response 

` 

` `json 
{ 
  "id": "id1", 
  "subbed": "market.btcusdt.trade.detail", 
  "ts":

> Update example

```json
{
  "ch": "market.btcusdt.trade.detail",
  "ts": 1489474082831, //system update time
  "tick": {
        "id": 14650745135,
        "ts": 1533265950234, //trade time
        "data": [
            {
                "amount": 0.0099,
                "ts": 1533265950234, //trade time
                "id": 146507451359183894799,
                "tradeId": 102043494568,
                "price": 401.74,
                "direction": "buy"
### Data update field list
```
}
  }
        ]
            }
            // more Trade Detail data here


| Field | Data Type | Description | 
| --------- | -------- | ---------------------- ------------------------ | 
| id | integer | unique transaction ID (will be discarded) | 
| tradeId | integer | unique transaction ID (NEW) | 
| amount | float | transaction volume (buy or sell side) | 
| price | float | transaction price| 
| ts | integer | transaction time (UNIX epoch time in millisecond) | | 
direction | string | Direction) : 'buy' or 'sell' | 

### Data request 

Supports data request method to obtain transaction details data at one time (only the most recent 300 transaction records can be obtained): `` 

`json 
{ 
  "req": "market. btcusdt.trade.detail", 
  "id": "id11"
}
``` 

## Market Summary 

### Topic Subscription 

This topic provides the latest market summary snapshot within 24 hours. The snapshot frequency does not exceed 10 times per second. 

`market.$symbol.detail` 

> Subscribe request 

```json 
{ 
  "sub": "market.btcusdt.detail", 
  "id": "id1" 
} 
``` 

### parameter 

| parameter | data type | whether required | default value | description | range of values ​​| 
| ------ | -------- | -------- | ------ | ----- --- | -------------------- | | symbol 
| 
string 
| true | NA | json

 
{ 
  "id": "
  "subbed": "market.btcusdt.detail",
  "ts": 1489474081631 //system response time
}
```

> Update example

  "ch": "market.btcusdt.detail",
  "ts": 1494496390001, //system update time
  "tick": {
    "amount": 12224.2922,
    "open":   9790.52,
    "close":  10195.00,
    "high":   10300.00,
    "id":     1494496390,
    "count":  15195,
    "low":    9657.00,
    "vol":    121906001.754751 
| id | integer | unix time, also used as message ID |
| ------ | -------- | ------------ ------------ |
| field | data type | description |
### Data update field list
```
}
  }


| amount | float | 24-hour trading volume | 
| count | integer | 24-hour transaction volume | 
| close | Price|
| open | float | 24-hour opening price|
| low | float | 24-hour lowest price | 
| 
high | | 

### Data request 

Support data request method to obtain market summary data at one time: 

```json 
{ 
  "req": "market.btcusdt.detail", 
  "id": "id11" 
} 
``` 


## 


# Websocket assets And order 

## Introduction 

### Access URL 

**Websocket Assets and Order** 

**`wss://api.bitv.com/ws/v2`**   

### Data Compression 

The data is not compressed by GZIP. 

### Heartbeat message 

When the user's Websocket client connects to the WebSocket server, the server will periodically (currently set to 20 seconds) send a `Ping` message to it and include an integer value as follows: ``` 

json 
{
	"action": "ping", 
	"data": { 
		"ts": 1575537778295 
	} 
} 
``` 

When the user's Websocket client receives this heartbeat information, it should return a `Pong` message containing the same integer value: ` 

` `json 
{ 
    "action": "pong", 
    "data": { 
          "ts":1575537778295 // Use the ts value in the Ping message 
    } 
} 
``` 

### Valid value of `action` 

| Valid value | Value description | 
| ---------- | ---- -------------------------------- | 
| sub | subscription data | 
| req | data request | 
| ping, pong | Heartbeat data | 
| push | Push data, the data type sent from the server to the client | 

### Frequency limit

This version adopts a multi-dimensional frequency limiting strategy for users. The specific strategy is as follows: 
 
- Restrict valid requests for a single connection (including req, sub, unsub , excluding ping/pong and other invalid requests) is **50 times/second** (here the second limit is a sliding window). When this limit is exceeded, a "too many request" error message is returned.
- Limit the total number of connections established with a single API Key to **10**. When this limit is exceeded, a "too many connection" error message is returned. 
- Limit the number of connections established by a single IP to **100 times/second**. When the limit is exceeded, a "too many request" error message will be returned. 

### Authentication 

The authentication request format is as follows: 

```json 
{ 
    "action": "req", 
    "ch": "auth", 
    "params": { 
        "authType": "api", 
        "accessKey": " e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx", 
        "signatureMethod": "HmacSHA256", 
        "signatureVersion": "2.1", 
        "timestamp": "2019-09-01T18:16:16", 
        "signature": "



	"ch": "auth", 
	"data": {} 
} 
``` 

parameter description 

| field | required | data type | description | 
| ---------------- | - ------- | -------- | ------------------------------ --------------------------- | 
| action | true | string | Websocket data operation type, the authentication fixed value is req | | 
ch | true | string | request subject, the fixed authentication value is auth | 
| authType | true | string | authentication type, the fixed authentication value is api. Note that this parameter is not included in the signature calculation. |  
| accessKey | true | string | AccessKey in the API Key you applied for |
| signatureMethod | true | string | signature method, the protocol for users to calculate the signature message hash, the fixed value is HmacSHA256 | | 
signatureVersion | true | string | signature protocol version, the fixed value is 2.1 |
| timestamp | true | string | Timestamp, the time (UTC time) when you make the request. Including this value in the query request helps prevent third parties from intercepting your request. Such as: 2017-05-11T16:22:06. Re-emphasis is (UTC time zone) | 
| signature | true | string | signature, calculated value, used to ensure that the signature is valid and has not been tampered with | 

### Signature steps 

Signature steps, you can in【Quick Start-Signature Authentication ] part to view. 

Note: Data in JSON requests does not need to be URL encoded. 

### Subscribe to a topic 

After successfully establishing a connection with the Websocket server, the Websocket client sends the following request to subscribe to a specific topic: `` 

`json 
{ 
	"action": "sub", 
	"ch": "accounts.update" 
} 
`` ` 

If ​​the subscription is successful, the Websocket client will receive the following message: 

```json  
{
	"action": "sub", 
	"code": 200, 
	"ch": "accounts.update#0", 
	"data":



{} // Request data body } 
``` 
### Error codes 
The following are the error codes, error messages and descriptions of the WebSocket asset and order interfaces.  
| 400 | Bad Request | Bad Request | 
| 404 | Not Found | Service not found|





| Error code | Error message | Description | 
| ------ | ------------------------ | -------- --------------------------------------- |
| 200 | True| Correct return| 
| 100 | Timeout close| 
Timeout close| 
| 
429 | invalid.ip | invalid ip | 
| 2001 | nvalid.json | invalid request json | 
| 
2001 
| | Invalid trading pair| 
| 2001 | invalid.ch | Invalid subscription | 
| 2001 | invalid.exchange | Invalid exchange code | 
| 2001 | missing.param.auth | missing signature verification parameters|
| 2002 | invalid.auth.state | Authentication failed | 
| 2002 | auth.fail | Signature verification failed | 
| 2003 | query.account.list.error | Query account list failed | 
| 4000 | too.many.request | Client End uplink request frequency limit | 
| 4000 | too.many.connection | Number of connections with the same key | 

## Subscribe order update 

API Key Permission: read 

The order update push is triggered by any of the following events:<br> 
In the messages pushed by different event types, the list of fields is slightly different. Developers can design the returned data structure in the following two ways:<

- Planning or tracking order trigger failure event (eventType=trigger)<br> 
- Planning or tracking order cancellation event before triggering (eventType=deletion)<br> 
- Order creation (eventType=creation)<br> 
- Order execution (eventType=trade)<br> 
- order cancellation (eventType=cancellation)<br> 
``` 
| parameter | data type | description |


- Define a data structure that contains all fields, and allow some fields to be empty<br> 
- Define different data structures, each containing their own fields, and inherit from a data structure that contains common data fields 

### Subscribe 

Topic` orders#${symbol}` 

### Subscription parameters 

> Subscribe request 

```json 
{ 
	"action": "sub", 
	"ch": "orders#btcusdt" 
} 

``` 

> Response 

```json 
{ 
	"action ": "sub", 
	"code": 200, 
	"ch": "orders#btcusdt", 
	"data": {} 
} 

| ------ | -------- | ---- --------------------- | 
| symbol | string | transaction code (support wildcard * ) | 

### data update field list 

> Update example 

```json 
{ 
	"action":"push",
	"ch":"orders#btcusdt",
	"data":
	{
		"orderSide":"buy",
		"lastActTime":1583853365586,
		"clientOrderId":"abc123",
		"orderStatus":"rejected",
		"symbol":"btcusdt",
		"eventType":"trigger",
		"errCode": 2002,
		"errMessage":"invalid.client.order.id (NT)"
| clientOrderId | string | user-defined order number|
| symbol | string | transaction code|
When the plan order/track order trigger fails –
```
}
	}

 
| field| data type| description|
| ------------- | -------- | -------------------------- ---------------------------------- | 
| eventType | string | event type, valid value: trigger (this event Only valid for planning order/tracking order) |
	{
| orderSide | string | order direction, valid value: buy,sell | 
| orderStatus | string | order status, valid value: rejected | 
| errCode | int | error code 
of order trigger failure | | errMessage | 
| lastActTime | long | Order trigger failure time | 

> Update example 

```json 
{ 
	"action":"push", 
	"ch":"orders#btcusdt", 
	"data": 
		"orderSide":"buy", 
		"lastActTime ":1583853365586, 
		"clientOrderId": "abc123", 
		"orderStatus":"canceled",
		"symbol":"btcusdt", 
		"eventType":"deletion" 
	} 
} 
``` 

When the planned order/tracking order is canceled before triggering – 

| field| Data Type | Description | 
| ------------- | -------- | --------------------- --------------------------------------- | 
| eventType | string | event type, valid value :deletion (this event is only valid for planning orders/tracking orders) | 
| symbol | string | transaction code | 
| clientOrderId | string | user-made order number | 
| orderSide |sell                                   |
| orderStatus | string | order status, valid value: canceled | 
| lastActTime | long | order cancellation time | 

> Update example
 
```json
{
	"action":"push",
	"ch":"orders#btcusdt",
	"data":
	{
		"orderSize":"2.000000000000000000",
		"orderCreateTime":1583853365586,
		"accountId":992701,
		"orderPrice":"77.000000000000000000",
		"type":"sell-limit",
		"orderId":27163533,
		"clientOrderId":"abc123",
		"orderStatus":"submitted",
		"symbol":"btcusdt",
		"eventType":"creation"
| --------------- | -------- | ------ -------------------------------------------------- ---- |
When the order is placed –
```
}
	}



| field | data type | description | 
| eventType | string | event type, valid value: creation | 
| symbol | string | transaction code | 
| accountId | long | account ID 
| 
| orderId | User-created order number (if any) | 
| orderPrice | string | order price | 
| orderSize | string | order quantity (invalid for market buy orders) |
| orderValue | string | order amount (only valid for market buy orders) | 
| type | string | order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell- limit-maker, buy-ioc, sell-ioc | 
| orderStatus | string | order status, valid value: submitted | 
| orderCreateTime | 
long 

| 
, the interface will not push the creation of this order;<br> 
- Before the Taker order is completed, the interface will first push its creation event. <br> 
- The order type of the stop loss order is no longer the original order type "buy-stop-limit" or "sell-stop-limit", but becomes "buy-limit" or "sell-limit". <BR> 

> Update example 

```json 
{ 
	"action":"push", 
	"ch":"orders#btcusdt", 
	" 
		"tradePrice":"76.000000000000000000", 
		"tradeVolume":"1.013157894736842100", 
		" tradeId": 301, 
		"tradeTime": 1583854188883,
		"orderId":27163536,
		"type":"sell-limit",
		"clientOrderId":"abc123",
		"orderStatus":"filled",
		"symbol":"btcusdt",
		"eventType":"trade"
| tradeVolume | string |
| tradePrice | string | transaction price |
| eventType | string | event type, valid value: trade |
| ------------- | -------- | -------- -------------------------------------------------- -- |
| field | data type | description |
When the order is completed –
```
}
	}


| symbol | string | trade code| 
| orderId | long | order ID | 
| type | string | order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell -limit-maker, buy-ioc, sell-ioc | 
| clientOrderId | string | user-made order number (if any) | 
| tradeId | long | transaction ID | 
| tradeTime | long | transaction time | 
| aggressor | bool | The active side of the transaction, valid values: true (taker), false (maker) | 
| orderStatus | string | order status, valid values: partial-filled, filled |
| remainAmt | string | Unfilled quantity (buy order at market price is the unfilled amount) | 

Note: <BR> 

- The order type of the stop loss order is no longer the original order type "buy-stop-limit" or "sell-stop- limit", it becomes "buy-limit" or "sell-limit". <BR> 
- When a taker order is executed with multiple orders of the counterparty at the same time, each resulting transaction (tradePrice, tradeVolume, tradeTime, tradeId, aggressor) will be pushed separately (instead of combined push). <BR> 

> Update example 

```json 
{ 
	"action":"push", 
	"ch":"orders#btcusdt", 
	"data": 
	{ 
		"lastActTime":1583853475406, 
		"remainAmt":"2.000000000000000000", 
		"orderId ":27163533, 
		"type":"sell-limit", 
		"clientOrderId":"abc123", 
		"
} 
``` 


| ------------- | -------- | ---------------------- -------------------------------------- | 
| eventType | string | event type, valid values: cancellation | 
| symbol | string | transaction code | 
| orderId | long | order ID | 
| type | string | order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker , sell-limit-maker, buy-ioc, sell-ioc | 
| clientOrderId | string | user-defined order number (if any) | 
| orderStatus | string | order status, valid values: partial-canceled, canceled |
| remainAmt | string | unexecuted quantity (buy order at market price is the unexecuted amount) | 
| lastActTime | long | last update time of the order | 

Note: <BR> 
| parameters | data type | required | description |

- The order type of the stop loss order is no longer the original order type "buy-stop-limit" or "sell-stop-limit", but becomes "buy-limit" or "sell-limit". <BR> 

## Update 

API Key Permissions: Read 

Push only when the user's order is completed or cancelled. Among them, the order transaction is pushed one by one. If a taker order is executed with multiple maker orders at the same time, this interface will push the update one by one. However, the order of these transaction messages received by the user may not be completely consistent with the actual order of transactions. In addition, if the execution and cancellation of an order occur almost at the same time, for example, the remaining part of an IOC order is automatically canceled after the execution, the user may receive the order cancellation push first, and then the execution push. <br> 

If the user needs to get order updates updated sequentially, it is recommended to subscribe to another channel orders#${symbol}. <br> 

### Subscribe topic 

`trade.clearing#${symbol}#${mode}` 

### Subscribe parameters 

| ------ | -------- | ----- --- | ---------------------------------------------- -------------- | 
| symbol | string | TRUE | transaction code (support wildcard * ) | 
| mode | int | FALSE | push mode (0 - push only when the order is executed; 1 - Push when the order is completed or canceled; default value: 0) | 

Note:<br>
Optional subscription parameter mode, if not filled or filled with 0, only transaction events will be pushed; if 1 is filled, transaction and cancellation events will be pushed. <br> 

> Subscribe request 

```json 
{ 
	"action": "sub", 
	"ch": "trade.clearing#btcusdt#0" 
} 

``` 

> Response 

```json 
{ 
	"action": "sub" , 
	"code": 200, 
	"ch": "trade.clearing#btcusdt#0", 
	"data": {} 
} 
``` 

> Update example 

```json 
    "ch": "trade.clearing#btcusdt#0 ", 
    "data": { 
         "eventType": "trade", 
         "symbol": "btcusdt", 
         "
         "aggressor": true,
         "tradeId": 919219323232,
         "tradeTime": 998787897878,
         "transactFee": "19.88",
         "feeDeduct ": "0",
         "feeDeductType": "",
         "feeCurrency": "btc",
         "accountId": 9912791,
         "source": "spot-api",
         "orderPrice": "10000",
         "orderSize": "1",
         "clientOrderId": "a001",
         "orderCreateTime": 998787897878,
         "orderStatus": "partial-filled"
| field | data type | description |
```
}
    }

### Data update field list (when the order is completed) 

| --------------- | -------- | ----------- -------------------------------------------------- | 
| eventType | string | event type (trade) | 
| symbol | string | transaction code | 
| orderId | long | order ID 
| | 
tradePrice 
| , valid values: buy, sell |
| orderType | string | order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker, buy-stop -limit,sell-stop-limit | 
| transaction fee deduction |
| aggressor | bool | Whether to be the active party of the transaction, valid values: true, false | 
| tradeId | long | transaction ID | 
| tradeTime | long | transaction time, unix time in millisecond | 
| transactFee | string | or transaction fee rebate (negative value) | 
| feeCurrency | string | transaction fee or transaction fee rebate currency (the transaction fee currency for buy orders is the base currency, and the transaction fee currency for sell orders is the quote currency type; the transaction fee rebate currency for buy orders is the pricing currency, and the transaction fee rebate currency for sell orders is the base currency) | | 
feeDeductType | string | transaction fee deduction type, valid values: ht, point | 
| accountId | long | account ID| 
| source | string | order source| 
| orderPrice | string | order price (the market price order does not have this field) | 
| orderSize | string | order quantity (the market price buy order does not have this field) | 
| orderValue | string | order amount (only market buy orders have this field) | 
| clientOrderId | string | user-defined order number | 
| stopPrice 
| | order triggering direction (only take profit and stop loss orders have this field) | 
| orderCreateTime | long | order creation time | 
| orderStatus | string | order status, valid values: filled, partial-filled |
 
Note:<br> 

- The transaction rebate amount in transactFee may not arrive in real time;<br> 

### Data Update the field list (when the order is canceled)

| Field | Data Type | Description | 
| --------------- | -------- | ---------------- ----------------------------------------------- | 
| eventType | string | event type (cancellation) | 
| symbol | string | transaction code | 
| orderId | long | order ID |  
| orderSide | string | Order direction, valid values: buy, sell |
| orderType | string | order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy -ioc,sell-ioc,buy-limit-maker,sell-limit-maker,buy-stop-limit,sell-stop-limit | 
| accountId | long | account number| 
| source | string | order source | 
| orderPrice | string | order price (the market price order does not have this field) | 
| orderSize 
| string | string | order amount (only market buy order has this field) | 
| clientOrderId | string | user-defined order number | 
| stopPrice | string | order trigger price (only stop-loss order has this field) | 
| Trigger Direction (Only for Take Profit and Stop Loss orders) |
| orderCreateTime | long | order creation time | 
| remainAmt | string | untraded volume (for a market buy order, this field is defined as the unfilled volume) |  
| orderStatus | string | order status, valid values: canceled, partial-canceled |

## Subscription Account Change 

API Key Permission: Read 

order updates under the subscription account. 

### To subscribe to the topic 

`accounts.update#${mode}`, 

the user can choose any of the following trigger methods for account change push: 

1. Push only when the account balance changes; 

2. When the account balance changes or the available balance changes Timely push, and push separately. 

### Subscription Parameters 

| Parameters | Data Type | Description | 
| ---- | -------- | ------------------- ----------- | 
| mode | integer | Push method, valid value: 0, 1, default value: 0 | 

Subscription example   
1, leave mode empty:   
accounts.update   
is only pushed when the account balance changes ;   
2. Fill in mode=0:   
accounts.update#0   
is only pushed when the account balance changes;   
3. Fill in mode=1:  
accounts.update#1   
is pushed when the account balance changes or the available balance changes and pushed separately.  

Note: No matter which subscription mode the user adopts, after the subscription is successful, the server will first push the current account balance and available balance of each account, and then push subsequent account updates. When the initial value of each account is first pushed, the values ​​of changeType and changeTime in the message are null.

> Subscribe request 

```json 
{ 
	"action": "sub", 
	"ch": "accounts.update" 
} 

``` 

> Response 

```json 
{ 
	"action": "sub", 
	"code": 200, 
	"ch": "accounts.update#0", 
	"data": {} 
} 
``` 

> Update example 

```json 
accounts.update#0: 
{ 
	"action": "push", 
	"ch": "accounts .update#0", 
	"data": { 
		"currency": "btc", 
		"
		"changeTime": 1568601800000
	}
}

accounts.update#1：
{
	"action": "push",
	"ch": "accounts.update#1",
	"data": {
		"currency": "btc",
		"accountId": 33385,
		"available": "2028.699426619837209087",
		"changeType": "order.match",
         		"accountType":"trade",
		"changeTime": 1574393385167
	}
}
{
	"action": "push",
	"ch": "accounts.update#1",
	"data": {
		"currency": "btc",
		"accountId": 33385,
		"balance": "2065.100267619837209301",
		"changeType": "order.match", 
### Data update field list
```
	}
		"changeTime": 1574393385122
           	"accountType": "trade",
}

 
| field | data type | description | 
| ----------- | -------- | ----------------- ---------------------------------------------- | 
| currency | string | coins type | 
| accountId | long | account ID | 
| balance | string | account balance (only pushed when the account balance changes) | 
| available | string | available balance (only pushed when the available balance changes) | | 
changeType | string | Balance change type, valid values: order-place (order creation), order-match (order transaction), order-refund (order transaction refund), order-cancel (order cancellation), order-fee-refund (deduction transaction fee) | 
| accountType | string | account type, valid values: trade, frozen, loan, interest | 
| changeTime | long | balance change time, unix time in millisecond | 

Note:<br>
The account update pushes the amount received, and multiple transaction rebates generated by multiple transactions may be combined into the account. 

<br> 
<br> 
<br> 
<br> 
<br>
