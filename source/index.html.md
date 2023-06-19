---
title: BitV API Documentation

language_tabs: # must be one of https://git.io/vQNgJ
  - json

toc_footers:
  - <a href='https://www.bitv.com/api/'>创建 API Key </a>
includes:

search: false

---

# Introduction

## API Introduction

Welcome to the BitV API!

This document is the only official API document of BitV. The features and services provided will be continuously updated here.

You can switch to get the API for different services by clicking the menu above, and you can also switch the language of the document by clicking the language button on the top right.

Examples of request parameters and response results are shown on the right side of the document.

## Update Subscription

We will notify you in advance about API additions, updates and downgrades. We suggest you pay attention to and subscribe to our announcements to get relevant information in time.

## Contact us

If you have any questions or inquiries regarding the use of the API, please refer to the `Q&A` for inquiries.

# Quick Start

## Access Preparation

To use the API, please log in to the web terminal and complete the API key application and permission configuration before developing and trading according to the details in this document.

You can create an API key by clicking [here ](https://www.bitv.com/api/).

Each parent user can create 20 groups of Api Key, and each Api Key can set three kinds of permissions: read, trade and withdraw coins.

Permissions are described as follows:

- Read permission: Read permission is used for the query interface of data, such as: order query, transaction query, etc.
- Trading permission: Trading permission is used for placing, withdrawing and transferring orders.
- Withdrawal permission: Withdrawal permission is used to create withdrawal orders and cancel withdrawal order operations.

After successful creation, please make sure to remember the following information:

- `Access Key` API access key

- `Secret Key` The key used for signature authentication encryption (only visible when applying)

<aside class="notice">
Each API Key can be bound to a maximum of 20 IP addresses (host or network addresses), and API Keys that are not bound to IP addresses are valid for 90 days. For security reasons, it is strongly recommended that you bind an IP address.
</aside>
<aside class="warning"> 
 <red><b>Risk Note</b></red>: These two keys are closely related to account security, please do not disclose them to other people <b>at</b> any time; API Key leakage may cause loss of your assets (even if you do not open withdrawal privileges), if you find API Key leakage, please delete the API Key as soon as possible.
</aside> 

## Interface Types

We provide two kinds of interfaces for users, you can choose the suitable way to check the quotes, trade or withdraw coins according to your usage scenarios and preferences.

### REST API

REST, which stands for Representational State Transfer, is a popular HTTP-based communication mechanism, where each URL represents a resource.

For one-time operations such as trading or withdrawing coins from assets, developers are recommended to use the REST API for operations.

### WebSocket API

WebSocket is a new protocol (Protocol) for HTML5. It implements full-duplex communication between client and server. A client-server connection can be established through a simple handshake, and the server can actively push information to the client according to business rules.

It is recommended that developers use the WebSocket API to obtain information such as market quotes and buying and selling depth.

**Interface Authentication**

Both of the above interfaces contain two types of public and private interfaces.

The public interface can be used to obtain basic information and quotation data. The public interface can be called without authentication.

The private interface can be used for trade management and account management. Each private request must be signed and authenticated using your API Key.

## Access URLs
**REST API**

**`https://api.bitv.com`**

**Websocket Feed (quotes, not including MBP incremental quotes)**

**`wss://api.bitv.com/ws`**

**Websocket Feed (ticker, MBP incremental ticker only)**

**`wss://api.bitv.com/feed`**

**Websocket Feed (assets and orders)**

*`*wss://api.bitv.com/ws/v2`*

## Signature Authentication

### Signature Description

To ensure that requests are not altered, private interfaces other than public interfaces (base information, ticker data) must be signed and authenticated with your API Key to verify that parameters or parameter values have not been altered in transit.  
Each API Key requires the appropriate permissions to access the corresponding interface, and each newly created API Key needs to be assigned permissions. Before using an interface, check the permission type for each interface and make sure your API Key has the appropriate permissions.

A legitimate request consists of the following components:

- Method request address: that is, access to the server address <https://api.bitv.com>
- API AccessId (AccessKeyId): The Access Key in the API Key you requested.
- SignatureMethod: The hash-based protocol used by the user to calculate the signature, here HmacSHA256 is used.
- SignatureVersion: The version of the signature protocol, here 2 is used.
- Timestamp: The time you sent the request (UTC time). For example: 2017-05-11T16:22:06. Including this value in the query request helps prevent third parties from intercepting your request.
- Required and Optional Parameters: Each method has a set of required and optional parameters that are used to define the API call. You can see these parameters and their meaning in the description of each method.
  - For GET requests, each method comes with its own parameters that require a signature operation.
  - For POST requests, each method's own parameters are not signed and need to be placed in the body.
- Signature: The value resulting from the signature calculation, which is used to ensure that the signature is valid and has not been tampered with.

### Signing steps

Because when using HMAC for signature computation, the result of the computation can be completely different using different content. Therefore, please normalize the request before performing the signature calculation. The following is an example of a request for order details:

The full request URL for an order detail query

`https://api.bitv.com/v1/order/orders?`

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`&SignatureMethod=HmacSHA256`

`&SignatureVersion=2`

`&Timestamp=2017-05-11T15:19:30`

`&order-id=1234567890`

**1. request method (GET or POST, GET for WebSocket), followed by the newline character "\n"**

For example: `GET\n`

**2. add the access domain name in lowercase, followed by the newline character "\n"**

For example: `api.bitv.com\n`

**3. add the path to the access method, followed by a line break "\n"**

For example, to check orders:<br/>`/v1/order/orders\n`<br/>

For example WebSocket v2<br/>`/ws/v2`<br/>

**4. URL encoding of the parameters and sorting them in ASCII order**

For example, here is the original order of the request parameters and after URL encoding

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`order-id=1234567890`

`SignatureMethod=HmacSHA256`

`SignatureVersion=2`

`Timestamp=2017-05-11T15%3A19%3A30`

<aside class="notice"> 
Use UTF-8 encoding and URL encoding, hexadecimal characters must be capitalized, e.g. ":" will be encoded as "%3A" and spaces are encoded as "%20".
</aside>
<aside class="notice"> 
Timestamp needs to be added in YYYY-MM-DDThh:mm:ss format and URL encoded.
</aside>

After sorting

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`SignatureMethod=HmacSHA256`

`SignatureVersion=2`

`Timestamp=2017-05-11T15%3A19%3A30`

`order-id=1234567890`

**5. In the above order, connect the parameters using the character "&"**

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15% 3A19%3A30&order-id=1234567890`

**6. compose the final string for the signature calculation as follows**

`GET\n`

`api.bitv.com\n`

`/v1/order/orders\n`

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15% 3A19%3A30&order-id=1234567890`


**7. Generate a digital signature with the "request string" created in the previous step and your Secret Key**

1. Use the request string from the previous step and the API private key as two parameters, call the HmacSHA256 hash function to obtain the hash value.
2. Base-64 encode this hash value to get the digital signature for this API call.

`4F65x5A2bLyMWVQj3Aqp+B4w+ivaA7n5Oi2SuYtCJ9o=`

**8. Include the generated digital signature in your request**

For Rest API:

1. Add all required authentication parameters to the path parameters of the interface call
2. URL encode the digital signature and add it to the path parameters, with the parameter name as "Signature".

Ultimately, the API request sent to the server should look like this:

`https://api.bitv.com/v1/order/orders?AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&order-id=1234567890&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15%3A19%3A30&Signature=4F65x5A2bLyMWVQj3Aqp%2BB4w%2BivaA7n5Oi2SuYtCJ9o%3D`

For WebSocket interface:

1. Fill in the parameters and signature as per the required JSON format.
2. The parameters in the JSON request do not need to be URL-encoded.

For example:

`
{
    "action": "req", 
    "ch": "auth",
    "params": { 
        "authType":"api",
        "accessKey": "e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx",
        "signatureMethod": "HmacSHA256",
        "signatureVersion": "2.1",
        "timestamp": "2019-09-01T18:16:16",
        "signature": "4F65x5A2bLyMWVQj3Aqp+B4w+ivaA7n5Oi2SuYtCJ9o="
    }
}
`
## Sub-Users

Sub-users can be used to segregate assets and transactions. Assets can be transferred between the main user and the sub-users. Sub-users can only trade within the sub-user's account, and assets cannot be directly transferred between sub-users - only the main user has transfer authority. 

Sub-users have independent login usernames, passwords, and API Keys, all of which are managed by the main user via the web interface. 

Each main user can create up to 200 sub-users. Each sub-user can create up to 5 sets of API Keys, each with the option to set read and trade permissions.

The API Key of a sub-user can also be bound to an IP address. The expiration limit is the same as the API Key of the main user.

Sub-users can access all public interfaces, including basic information and market trends. Sub-users have access to the following private interfaces:

| Interface                                                         | Explanation                            |
| ------------------------------------------------------------ | ------------------------------- |
| [POST /v1/order/orders/place](#fd6ce2a756)                   | Create and execute orders                  |
| [POST /v1/order/orders/{order-id}/submitcancel](#4e53c0fccd) | Cancel an order                   |
| [POST /v1/order/orders/submitCancelClientOrder](#client-order-id) | Cancel order (based on client order ID) |
| [POST /v1/order/orders/batchcancel](#ad00632ed5)             | Batch cancel orders                    |
| [POST /v1/order/orders/batchCancelOpenOrders](#open-orders)  | Cancel current order delegation               |
| [GET /v1/order/orders/{order-id}](#92d59b6aad)               | Query order details                |
| [GET /v1/order/orders](#d72a5b49e7)                          | Query current and historical delegation         |
| [GET /v1/order/openOrders](#95f2078356)                      | Query current delegated orders               |
| [GET /v1/order/matchresults](#0fa6055598)                    | Query transactions                       |
| [GET /v1/order/orders/{order-id}/matchresults](#56c6c47284)  | Query transaction details of an order         |
| [GET /v1/account/accounts](#bd9157656f)                      | Query all accounts of the current user          |
| [GET /v1/account/accounts/{account-id}/balance](#870c0ab88b) | Query balance of a specific account              |
| [GET /v1/account/history](#84f1b5486d)                       | Query account history                    |
| [GET /v2/account/ledger](#2f6797c498)                        | Query financial history                    |
| [POST /v1/account/transfer](#0d3c2e7382)                     | Asset transfer                        |

<aside class="notice">
Other interfaces cannot be accessed by sub-users. If an attempt is made, the system will return "error-code 403".
</aside>

## Business Glossary

### Trading Pairs

Trading pairs consist of a base currency and a quote currency. For example, in the trading pair BTC/USDT, BTC is the base currency, and USDT is the quote currency.

The field corresponding to the base currency is called `base-currency`.

The field corresponding to the quote currency is called `quote-currency`.

### Accounts

Different businesses require different types of accounts. The `account-id` is a unique identifier for each business account.

The `account-id` can be obtained through the `/v1/account/accounts` interface, and the specific account type can be determined based on the `account-type`.

Account types include:

- Spot: Spot trading account

### Order and Trade-related ID Explanation

- `order-id`: A unique identifier for an order.
- `client-order-id`: A customer-defined ID that is passed in during order placement. It corresponds to the `order-id` returned after a successful order placement. This ID is valid for 24 hours. Allowed characters include letters (case-sensitive), numbers, underscores (_), and dashes (-), with a maximum length of 64 characters.
- `match-id`: A sequential number assigned to an order during the matching process.
- `trade-id`: A unique identifier for a trade.

### Order Types

The order type is determined by the combination of the trade direction and the order operation type. For example, "buy-market" consists of the buy direction and the market operation type.

Trade directions:

- Buy: Buy
- Sell: Sell

Order types:

- Limit: A limit order requires specifying the order price and quantity.
- Market: A market order only requires specifying the order amount or quantity, without specifying a price. The order is matched directly with the counterparty until the amount or quantity is lower than the minimum trade amount or quantity.
- Limit-maker: A limit order that can only enter the market depth as a maker. If the order would result in a match, the matching process will directly reject the order.
- IOC: Immediate or cancel. After entering the matching process, if the order cannot be immediately matched, it will be canceled (the remaining part will also be canceled after partial fulfillment).
- Stop-limit: A stop-loss or take-profit order that is set above or below the market price. The order is only officially placed in the matching queue when the trigger price is reached.

### Order Status

- Submitted: Waiting for fulfillment. Orders in this status have entered the matching queue.
- Partial-filled: Partially filled. Orders in this status are in the matching queue, and a portion of the order quantity has been filled by the market, waiting for the remaining part to be filled.
- Filled: Filled. Orders in this status are not in the matching queue anymore, and the entire order quantity has been filled by the market.
- Partial-canceled: Partially filled and canceled. Orders in this status are not in the matching queue anymore. They transition from the `partial-filled` status, where a portion of the order quantity was filled but later canceled.
- Canceled: Canceled. Orders in this status are not in the matching queue anymore. They have not been filled and have been successfully canceled.
- Canceling: Canceling. Orders in this status are in the process of being canceled. The order needs to be removed from the matching queue to be completely canceled, so this status serves as an intermediate state.

# Integration Guide

## API Overview

| API Category | Category Link                | Description                                          |
| ------------ | ---------------------------- | ---------------------------------------------------- |
| Basic        | /v1/common/*                 | Basic APIs, including currency, trading pair, timestamp, etc. |
| Market       | /market/*                    | Public market APIs, including trades, depth, market data, etc. |
| Account      | /v1/account/*  /v1/subuser/* | Account APIs, including account information, subusers, etc. |
| Order        | /v1/order/*                  | Order APIs, including order placement, cancellation, order query, trade query, etc. |

This categorization provides a general overview, but some APIs may not follow this convention. Please refer to the corresponding API documentation based on your specific needs.

## New Rate Limit Rules

- Currently, the new rate limit rules are gradually being implemented. APIs that have a separate rate limit value and are marked as "NEW" are subject to the new rate limit rules.

- The new rate limit rules adopt a frequency limit mechanism based on the UID. This means that the total frequency of requests from all API keys under the same UID to a single node cannot exceed the maximum allowed access times within a unit time period.

- Users can check the current rate limit usage and the expiration time of the time window by referring to the "X-HB-RateLimit-Requests-Remain" (remaining rate limit count) and "X-HB-RateLimit-Requests-Expire" (window expiration time) in the HTTP header. Adjust your request frequency dynamically based on this value.

## Rate Limit Rules

Except for APIs that have a separate rate limit value marked as "NEW" -

* Each API Key is limited to 10 requests within 1 second.
* If an API does not require an API Key, each IP is limited to 10 requests within 1 second.

For example:

* Asset and order APIs are rate-limited based on the API Key: 10 requests per second.
* Market APIs are rate-limited based on the IP: 10 requests per second.

## Request Format

All API requests are RESTful and currently support two methods: GET and POST.

* GET requests: All parameters are passed in the path parameters.
* POST requests: All parameters are sent in the request body as JSON format.

## Response Format

All APIs return data in JSON format. There are slight differences in the JSON structure between v1 and v2 APIs.

**v1 API response format**: The top-level structure consists of four fields: `status`, `ch`, `ts`, and `data`. The first three fields represent the request status and attributes, and the actual business data is contained in the `data` field.

Here is an example of the response format:

```json
{
  "status": "ok",
  "ch": "market.btcusdt.kline.1day",
  "ts": 1499223904680,
  "data": // per API response data in nested JSON object
}
```
  
| Field Name | Data Type | Description                                                  |
| ---------- | --------- | ------------------------------------------------------------ |
| code       | int       | API interface response code                                  |
| message    | string    | Error message (if any)                                       |
| data       | object    | Main data returned by the interface                          |


**v2 API response format**: The top-level structure consists of three fields: `code`, `message`, and `data`. The first two fields represent the response code and the error message, respectively. The actual business data is contained in the `data` field.

Here is an example of the response format:

```json
{
  "code": 200,
  "message": "",
  "data": // per API response data in nested JSON object
}
```
  
| Field Name | Data Type | Description                                                  |
| ---------- | --------- | ------------------------------------------------------------ |
| code       | int       | API interface response code                                  |
| message    | string    | Error message (if any)                                       |
| data       | object    | Main data returned by the interface                          |








## Data Types

This document describes the conventions for data types in the JSON format:

- `string`: String type, enclosed in double quotation marks (")
- `int`: 32-bit integer, mainly used for status codes, sizes, counts, etc.
- `long`: 64-bit integer, mainly used for IDs and timestamps.
- `float`: Floating-point number, mainly used for amounts and prices. It is recommended to use high-precision floating-point types in your program.
- `object`: Object, containing a sub-object {}
- `array`: Array, containing multiple objects

## Best Practices

### Security

- Strongly recommended: When applying for an API Key, bind it to your IP address to ensure that your API Key can only be used from your own IP. Additionally, an API Key without an IP binding is valid for 90 days, while an IP-bound API Key will never expire.
- Strongly recommended: Do not expose your API Key to anyone, including third-party software or organizations. The API Key represents your account privileges, and its exposure may result in loss of information and funds. If your API Key is compromised, please delete it promptly and create a new one.

### Public

**New Rate Limit Rules**

- The latest rate limit rules are gradually being implemented. The interfaces with the rate limit value specifically marked are subject to the new rate limit rules.
- Users can check the current rate limit usage and the expiration time of the time window using the "X-HB-RateLimit-Requests-Remain" and "X-HB-RateLimit-Requests-Expire" fields in the HTTP header. Adjust your request frequency dynamically based on these values.
- The frequency of requests from different API Keys under the same UID to a single node must not exceed the maximum allowed access limit within a unit time.

### Market Data

**Obtaining Market Data**

- For market data, it is recommended to use WebSocket to receive real-time data updates and cache the data in your program. WebSocket provides higher real-time performance and is not subject to rate limits.
- It is recommended not to subscribe to too many topics and currency pairs on the same WebSocket connection. Excessive data volume from the upstream provider may lead to network congestion and connection interruptions.

**Obtaining Latest Trade Price**

- It is recommended to subscribe to the `market.$symbol.trade.detail` topic via WebSocket. This topic provides tick-by-tick trade information, and the price in this data represents the latest trade price with higher real-time accuracy.

**Obtaining Order Book Depth**

- If you only need the best bid and ask prices (level 1) for the order book, you can subscribe to the `market.$symbol.bbo` topic via WebSocket. This topic will push updates when the best bid or ask price changes.
- If you need multiple levels of data and real-time accuracy is not critical, you can subscribe to the `market.$symbol.depth.$type` topic via WebSocket. This topic provides updates every 1 second.
- If you need multiple levels of data with high real-time accuracy, you can subscribe to the `market.$symbol.mbp.$levels` topic via WebSocket and send a req request. You can build and update the local order book based on the incremental updates received from this topic. The fastest update frequency for this topic is 100ms.
- It is recommended to use the `Rest` API (`/market/depth`) and WebSocket full data push (`market.$symbol.depth.$type`) to obtain the order book depth. When using these methods, you can deduplicate the data based on the `version` field (discard the smaller version). When using WebSocket incremental updates (`market.$symbol.mbp.$levels`), you can deduplicate the data based on the `seqNum` field (discard the smaller seqNum).

**Obtaining Latest Trades**

- When subscribing to the WebSocket trade details (`market.$symbol.trade.detail`) topic, it is recommended to deduplicate the data based on the `tradeId` field.

### Order Management

**Placing Orders (/v1/order/orders/place)**

- It is recommended to validate the order price, quantity, and other parameters against the currency pair data returned by the `/v1/common/symbols` API before placing an order. This helps to avoid sending invalid order requests.
- It is recommended to include the `client-order-id` parameter when placing an order. Ensure that this parameter is unique for each request. The `client-order-id` can be used to verify the order information received via WebSocket in case the API times out or fails to respond. You can also use the `/v1/order/orders/getClientOrder` API to query the order details based on the `client-order-id`.

**Search Historical Orders (/v1/order/orders)**

- It is recommended to use the `start-time` and `end-time` parameters for querying historical orders. The parameter value should be a 13-digit timestamp (accurate to milliseconds). The maximum time window for querying is 48 hours (2 days). It is recommended to query hourly. The smaller the time range, the higher the timestamp accuracy, and the more efficient the query. You can iterate the query based on the timestamp of the last query.

**Order Status Notifications**

- It is recommended to subscribe to the `orders.$symbol.update` topic via WebSocket. This topic provides lower data latency and more accurate message ordering.
- It is not recommended to subscribe to the `orders.$symbol` topic via WebSocket as it has been replaced by `orders.$symbol.update`. Please switch to the new topic as the old one will be discontinued.

### Account Management

**Asset Changes**

- Use WebSocket to subscribe to both the `orders.$symbol.update` and `accounts.update#${mode}` topics. The `orders.$symbol.update` topic is used to receive order status changes (creation, execution, cancellation) and related trade price and quantity information. Since this topic pushes data without clearing, it has faster timeliness. You can receive asset changes related to your account using the `accounts.update#${mode}` topic to maintain an updated view of your account funds.
- It is not recommended to subscribe to the `accounts` topic via WebSocket as it has been replaced by `accounts.update#${mode}`. Please switch to the new topic as the old one will be discontinued.

# common problem

## API information notification

Announcements will be issued in advance to notify you of new API additions, updates, and offline information. It is recommended that you pay attention to and subscribe to our announcements to obtain relevant information in a timely manner.

## Access and signature related

### Q1: How many Api Keys can a user apply for?

A: Each parent user can create 5 groups of Api Keys, and each Api Key can be set with three permissions: reading, trading, and withdrawal.
Each parent user can also create 200 sub-users, and each sub-user can create 5 sets of Api Keys, and each Api Key can be set with two permissions for reading and trading.

The following are descriptions of the three permissions:

- Read permission: read permission is used for data query interface, such as: order query, transaction query, etc.
- Transaction authority: transaction authority is used for placing orders, canceling orders, and transferring interfaces.
- Withdrawal permission: Withdrawal permission is used to create withdrawal orders and cancel withdrawal orders.

### Q2: Why do disconnections and timeouts often occur?

A: Please check whether it belongs to the following situations:

1. If the client server is located in mainland China, it is difficult to guarantee the stability of the connection.

### Q3: Why is WebSocket always disconnected?

A: The common reasons are:

1. If Pong is not replied, the WebSocket connection needs to reply Pong after receiving the Ping message sent by the server to ensure the stability of the connection.

2. Due to network reasons, the client sent a Pong message, but the server did not receive it.

3. The connection is disconnected due to network reasons.

4. It is recommended that users implement a WebSocket connection disconnection and reconnection mechanism. After ensuring that the heartbeat (Ping/Pong) message is correctly replied, if the connection is accidentally disconnected, the program can automatically reconnect.

### Q4: Why does the signature verification always fail?

A: Please compare the difference between the string before signing with Secret Key and the following string

Please note the following points when comparing:

1. Signature parameters should be sorted according to ASCII code. For example, the following are the original parameters:

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`order-id=1234567890`

`SignatureMethod=HmacSHA256`

`SignatureVersion=2`

`Timestamp=2017-05-11T15%3A19%3A30`

After sorting it should be:

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`SignatureMethod=HmacSHA256`

`SignatureVersion=2`

`Timestamp=2017-05-11T15%3A19%3A30`

`order-id=1234567890`

2. The signature string needs to be URL-encoded. for example:

- A colon `:` will be encoded as `%3A` and a space will be encoded as `%20`
- Timestamp needs to be formatted as `YYYY-MM-DDThh:mm:ss` and URL-encoded as `2017-05-11T15%3A19%3A30`

3. The signature needs to be base64 encoded

4. Get request parameters need to be in the signature string

5. The time is UTC time converted to YYYY-MM-DDTHH:mm:ss

6. Check whether there is a deviation between the local time and the standard time (the deviation should be less than 1 minute)

7. When WebSocket sends a signature verification and authentication message, the message body does not need URL encoding

8. The Host in the signature should be the same as the Host in the request interface

If you use a proxy, the proxy may change the request Host, you can try to remove the proxy;

The network connection library you use may include the port in the Host, you can try to include the port in the Host used in the signature

9. Whether there are hidden special characters in Api Key and Secret Key, which will affect the signature



### Q5: Why is the gateway-internal-error error returned by calling the interface?

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

### Q7: What is the reason for calling the Rest interface and returning HTTP 405 error method-not-allowed?

A: This error indicates that a Rest interface that does not exist has been called. Please check whether the path of the Rest interface is accurate. Due to the settings of Nginx, the request path (Path) is case-sensitive, please strictly follow the case stated in the document.

## market related

### Q1: How often is the current handicap data updated?

A: The current handicap data is updated once a second, whether it is a RESTful query or a Websocket push, it is updated once a second. If you need real-time bid, sell, and price data, you can use WebSocket to subscribe to the topic market.$symbol.bbo, which will push the latest bid, sell, and price data in real time.

### Q2: Will the trading volume of the 24-hour market interface (/market/detail) data interface experience negative growth?

A: The transaction volume and transaction amount in the /market/detail interface are 24-hour rolling data (the size of the translation window is 24 hours), and the cumulative transaction volume and transaction amount in the latter window may be smaller than the previous window.

### Q3: How to get the latest transaction price?

A: It is recommended to use the REST API `GET /market/trade` interface to request the latest transaction, or use WebSocket to subscribe to the market.$symbol.trade.detail topic, and obtain it according to the price in the returned data.

### Q4: When is the K-line calculated?

A: The K-line period is calculated based on Singapore time. For example, the starting period of the daily K-line is from 0:00 Singapore time to 0:00 Singapore time the next day.

## Transaction related

### Q1: What is account-id?

A: account-id corresponds to the ID of different business accounts of the user, which can be obtained through the /v1/account/accounts interface, and specific accounts are distinguished according to account-type.

Account types include:

- spot spot account

### Q2: What is client-order-id?

A: The client-order-id is a parameter of the order request identification, the type is a string, and the length is 64. This id is generated by the user and is valid within 24 hours.

### Q3: How to obtain the order quantity, amount, decimal limit, precision information?

A: You can use the Rest API `GET /v1/common/symbols` to obtain relevant currency pair information. When placing an order, pay attention to the difference between the minimum order quantity and the minimum order amount.

Common return errors are as follows:

- order-value-min-error: The order amount is less than the minimum transaction amount
- order-orderprice-precision-error : limit order price precision error
- order-orderamount-precision-error : Order quantity precision error
- order-limitorder-price-max-error : The limit order price is higher than the limit price threshold
- order-limitorder-price-min-error : The limit order price is lower than the limit price threshold
- order-limitorder-amount-max-error : The limit order amount is higher than the limit price threshold
- order-limitorder-amount-min-error : The limit order quantity is lower than the limit price threshold

### Q4: What is the difference between the WebSocket order update push topic orders.\$symbol and orders.$symbol.update?

A: The differences are as follows:

1. The order.\$symbol theme is an old push theme, and the maintenance and use of the theme will stop after a period of time. It is recommended to use the order.$symbol.update theme.

2. The new topic orders.$symbol.update has strict timing, which ensures that data is pushed strictly in the order of matching transactions, and has faster timeliness and lower delay.

3. In order to reduce the amount of repeated data push and achieve faster speed, the original order quantity and price information are not carried in the push of orders.$symbol.update. If this information is needed, it is recommended to maintain the order information locally when placing an order, or After receiving the push message, use the Rest interface to query.

### Q5: Why is the balance insufficient when placing an order again after receiving the message that the order has been successfully filled?

A: In order to ensure the timely delivery of orders and low latency, the result of order push is pushed directly after matching. At this time, the order may not have completed the liquidation of assets.

It is recommended to use the following methods to ensure that funds can be placed correctly:

1. Combined with the asset push topic `accounts`, receive asset change messages synchronously to ensure that funds have been cleared.

2. When receiving the order push message, use the Rest interface to call the account balance to verify whether the account funds are sufficient.

3. Keep a relatively sufficient fund balance in the account.

### Q6: What is the difference between filled-fees and filled-points in the matching results?

A: There are two types of transaction fees in matchmaking transactions: ordinary fees and deductible fees, and the two types will not exist at the same time.

1. Ordinary handling fee means that the deduction is not enabled at the time of the transaction, and the original currency is used for the deduction of the handling fee. For example: when purchasing BTC under the BTCUSDT currency pair, the filled-fees field is not empty, indicating that the normal handling fee has been deducted, and the unit is BTC.

2. The deduction of handling fee means that when the transaction is completed, the deduction is turned on, and the deduction asset is used as the deduction of the handling fee. For example, when purchasing BTC under the BTCUSDT currency pair, when the deduction assets are sufficient, filled-fees is empty, and filled-points is not empty, indicating that the deduction assets are deducted as a handling fee. The deduction unit needs to refer to the fee-deduct-currency field

### Q7: What is the difference between match-id and trade-id in the matching results?

A: match-id indicates the sequence number of the order in matching, and trade-id indicates the sequence number at the time of transaction. A match-id may have multiple trade-ids (at the time of transaction), or may not have trade-id (creating order, canceling Order)

### Q8: Why does placing an order based on the price of buying one or selling one in the current market trigger an order limit error?

A: Currently, there is price limit protection based on the latest transaction price. For coins with poor liquidity, placing an order based on market data may trigger price limit protection. It is recommended to place an order based on the transaction price + handicap data information pushed by ws

## Account deposit and withdrawal related

### Q1: Why does it return an api-not-support-temp-addr error when creating a withdrawal?

A: Due to security considerations, the API only supports addresses that are already in the withdrawal address list when creating withdrawals. It does not currently support using the API to add addresses to the withdrawal address list. You need to add addresses on the web page or APP before you can use them. Withdraw operations in the API.

### Q2: Why is the Invaild-Address error returned when USDT is withdrawn?

A: The USDT currency is a typical one-coin multi-chain currency. When creating a withdrawal order, you should fill in the address type corresponding to the chain parameter. The following table shows the correspondence between chains and chain parameters:

| chain | chain parameter |
| -------------- | ---------- |
| ERC20 (default) | usdterc20 |
| OMNI | usdt |
| TRX | trc20usdt |

If the chain parameter is empty, the default chain is ERC20, or you can also assign the parameter to `usdterc20`.

If you want to withdraw coins to OMNI or TRX, the chain parameter should be filled with usdt or trc20usdt. Please refer to the `GET /v2/reference/currencies` interface for available values of the chain parameter.


### Q3: How to fill in the fee field when creating a withdrawal?

A: Please refer to the return value of the GET /v2/reference/currencies interface. The withdrawFeeType in the returned information is the type of withdrawal fee. Select the corresponding field according to the type to set the withdrawal fee.

Withdrawal fee types include:

- transactFeeWithdraw : single withdrawal fee (only valid for fixed type, withdrawFeeType=fixed)
- minTransactFeeWithdraw : Minimum single withdrawal fee (only valid for interval type, withdrawFeeType=circulated or ratio)
- maxTransactFeeWithdraw : The maximum single withdrawal fee (only valid for interval type and ratio type with upper limit, withdrawFeeType=circulated or ratio
- transactFeeRateWithdraw : single withdrawal fee rate (only valid for ratio type, withdrawFeeType=ratio)

### Q4: How to check my withdrawal amount?

A: Please refer to the return value of the /v2/account/withdraw/quota interface. The returned information includes the single, current, current, total withdrawal quota and remaining quota information of the currency you inquired about.

Remarks: If you have a large amount of withdrawal needs, and the withdrawal amount exceeds the relevant limit, you can contact the official customer service for communication.

# basic information

## Introduction

The basic information Rest interface provides public reference information such as market status, transaction pair information, currency information, currency chain information, and server timestamp.

## Get the current market status

This node returns the current latest market state. <br>
Status enumeration values include: 1 - Normal (Orders can be placed and canceled), 2 - Pending (Orders cannot be placed and canceled), 3 - Cancellation only (Orders cannot be placed and canceled). <br>
Suspend reason enumeration values include: 2 - emergency maintenance, 3 - planned maintenance. <br>

```shell
curl "https://api.bitv.com/v2/market-status"
```


### HTTP requests

- GET `/v2/market-status`

### Request parameters

This interface does not accept any parameters.

> Responses:

```json
{
     "code": 200,
     "message": "success",
     "data": {
         "marketStatus": 1
     }
}
```

### return fields

| Name             | Type    | Required | Description                                                                                           |
| -----------------| ------- | -------- | ----------------------------------------------------------------------------------------------------- |
| code             | integer | TRUE     | Status code                                                                                            |
| message          | string  | FALSE    | Error description (if any)                                                                             |
| data             | object  | TRUE     |                                                                                                       |
| marketStatus     | integer | TRUE     | Market status (1=normal, 2=halted, 3=cancel-only)                                                      |
| haltStartTime    | long    | FALSE    | Market pause start time (Unix time in milliseconds), valid only for marketStatus=halted or cancel-only |
| haltEndTime      | long    | FALSE    | Expected end time of market suspension (Unix time in milliseconds), valid only for marketStatus=halted or cancel-only. If not returned, the end time is temporarily unpredictable. |
| haltReason       | integer | FALSE    | Reason for market suspension (2=emergency maintenance, 3=scheduled maintenance), valid only for marketStatus=halted or cancel-only |
| affectedSymbols  | string  | FALSE    | A list of trading pairs affected by market suspension, separated by commas. If all trading pairs are affected, return "all". Valid only for marketStatus=halted or cancel-only. |


## Get all trading pairs

This interface returns all supported trading pairs.

```shell
curl "https://api.bitv.com/v1/common/symbols"
```


### HTTP requests

- GET `/v1/common/symbols`

### Request parameters

This interface does not accept any parameters.

> Responses:

```json
{
     "status": "ok",
     "data": [
         {
             "base-currency": "btc",
             "quote-currency": "usdt",
             "price-precision": 2,
             "amount-precision": 6,
             "symbol-partition": "main",
             "symbol": "btcusdt",
             "state": "online",
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
             "funding-leverage-ratio": 3,
             "api-trading": "enabled"
         },
      …
     ]
}
```

### return fields

| Field Name               | Required | Data Type | Description                                                                                            |
| ------------------------ | -------- | --------- | ------------------------------------------------------------------------------------------------------ |
| base-currency            | true     | string    | Base currency in the transaction pair                                                                 |
| quote-currency           | true     | string    | Quote currency in the trading pair                                                                    |
| price-precision          | true     | integer   | Precision of the trading pair quotation (digits after the decimal point)                                |
| amount-precision         | true     | integer   | Precision of the trading pair base currency counting (digits after the decimal point)                  |
| symbol-partition         | true     | string    | Transaction partition; possible values: [main, innovation]                                            |
| symbol                   | true     | string    | Trading pair                                                                                          |
| state                    | true     | string    | Trading pair status; possible values: [online, offline, suspend, pre-online]                          |
| value-precision          | true     | integer   | Precision of the transaction amount of the trading pair (digits after the decimal point)               |
| min-order-amt            | true     | float     | Minimum order size of a limit order for the trading pair, in the base currency (to be obsolete)       |
| max-order-amt            | true     | float     | Maximum order size of a limit order for the trading pair, in the base currency (to be obsolete soon)  |
| limit-order-min-order-amt | true     | float     | Minimum order size of a limit order for the trading pair, in the base currency (NEW)                   |
| limit-order-max-order-amt | true     | float     | Maximum order size of a limit order for the trading pair, in the base currency (NEW)                   |
| sell-market-min-order-amt | true     | float     | Minimum order size of a market sell order for the trading pair, in the base currency (NEW)             |
| sell-market-max-order-amt | true     | float     | Maximum order size of a market sell order for the trading pair, in the base currency (NEW)             |
| buy-market-max-order-value| true     | float     | Maximum order value of a buy order at the market price of the trading pair, in the unit of pricing currency (NEW) |
| min-order-value          | true     | float     | Minimum order amount for a limit order and a market buy order for the trading pair, in the pricing currency |
| max-order-value          | false    | float     | Maximum order amount of a limit order and a market buy order for the trading pair, in converted USDT (NEW) |
| api-trading              | true     | string    | API trading enable flag (valid value: enabled, disabled)                                              |

## Get all currencies

This interface returns all supported currencies.


```shell
curl "https://api.bitv.com/v1/common/currencys"
```

### HTTP requests

- GET `/v1/common/currencys`


### Request parameters

This interface does not accept any parameters.


> Response:

```json
   "data": [
     "usdt",
     "eth",
     "etc"
   ]
```

### return fields


<aside class="notice">The returned "data" object is an array of strings, and each string represents a supported currency. </aside>

## APIv2 coin chain reference information

This node is used to query the static reference information (public data) of each currency and its blockchain

### HTTP requests

- GET `/v2/reference/currencies`

```shell
curl "https://api.bitv.com/v2/reference/currencies?currency=usdt"
```

### Request parameters

| Field Name      | Required | Type    | Field Description     | Value Range                                            |
| --------------- | -------- | ------- | --------------------- | ------------------------------------------------------ |
| currency        | false    | string  | Currency              | btc, ltc, bch, eth, etc ... (refer to `GET /v1/common/currencys`) |
| authorizedUser  | false    | boolean | Authenticated User    | true or false (default: true if not filled)             |


> Response:

```json
{
     "code":200,
     "data":[
         {
             "chains":[
                 {
                     "chain": "trc20usdt",
                     "displayName": "",
                     "baseChain": "TRX",
                     "baseChainProtocol": "TRC20",
                     "isDynamic": false,
                     "depositStatus": "allowed",
                     "maxTransactFeeWithdraw": "1.00000000",
                     "maxWithdrawAmt": "280000.00000000",
                     "minDepositAmt": "100",
                     "minTransactFeeWithdraw": "0.10000000",
                     "minWithdrawAmt": "0.01",
                     "numOfConfirmations": 999,
                     "numOfFastConfirmations": 999,
                     "withdrawFeeType": "circulated",
                     "withdrawPrecision": 5,
                     "withdrawQuotaPerDay": "280000.00000000",
                     "withdrawQuotaPerYear": "2800000.00000000",
                     "withdrawQuotaTotal": "2800000.00000000",
                     "withdrawStatus": "allowed"
                 },
                 {
                     "chain": "usdt",
                     "displayName": "",
                     "baseChain": "BTC",
                     "baseChainProtocol": "OMNI",
                     "isDynamic": false,
                     "depositStatus": "allowed",
                     "maxWithdrawAmt": "19000.00000000",
                     "minDepositAmt": "0.0001",
                     "minWithdrawAmt": "2",
                     "numOfConfirmations": 30,
                     "numOfFastConfirmations": 15,
                     "transactFeeRateWithdraw": "0.00100000",
                     "withdrawFeeType": "ratio",
                     "withdrawPrecision": 7,
                     "withdrawQuotaPerDay": "90000.00000000",
                     "withdrawQuotaPerYear": "111000.00000000",
                     "withdrawQuotaTotal": "1110000.00000000",
                     "withdrawStatus": "allowed"
                 },
                 {
                     "chain": "usdterc20",
                     "displayName": "",
                     "baseChain": "ETH",
                     "baseChainProtocol": "ERC20",
                     "isDynamic": false,
                     "depositStatus": "allowed",
                     "maxWithdrawAmt": "18000.00000000",
                     "minDepositAmt": "100",
                     "minWithdrawAmt": "1",
                     "numOfConfirmations": 999,
                     "numOfFastConfirmations": 999,
                     "transactFeeWithdraw": "0.10000000",
                     "withdrawFeeType": "fixed",
                     "withdrawPrecision": 6,
                     "withdrawQuotaPerDay": "180000.00000000",
                     "withdrawQuotaPerYear": "200000.00000000",
                     "withdrawQuotaTotal": "300000.00000000",
                     "withdrawStatus": "allowed"
                 }
             ],
             "currency": "usdt",
             "instStatus": "normal"
         }
         ]
}

```

### Response data

| field name            | required | data type | field description                                                                                       | value range |
|-----------------------|----------|-----------|---------------------------------------------------------------------------------------------------------|-------------|
| code                  | true     | int       | status code                                                                                             |             |
| message               | false    | string    | error description (if any)                                                                              |             |
| data                  | true     | object    |                                                                                                         |             |
| currency              | true     | string    | currency                                                                                                |             |
| chains                | true     | object    |                                                                                                         |             |
| chain                 | true     | string    | chain name                                                                                              |             |
| displayName           | true     | string    | chain display name                                                                                      |             |
| baseChain             | false    | string    | underlying chain name                                                                                   |             |
| baseChainProtocol     | false    | string    | underlying chain protocol                                                                               |             |
| isDynamic             | false    | boolean   | Whether dynamic fee (only valid for fixed type, withdrawFeeType=fixed)                                 | true, false |
| numOfConfirmations    | true     | int       | The number of confirmations required for secure account login (coin withdrawals are allowed after reaching the number of confirmations) |             |
| numOfFastConfirmations| true     | int       | The number of confirmations required for fast account transfer (transactions are allowed but withdrawals are not allowed after reaching the number of confirmations) |             |
| minDepositAmt         | true     | string    | minimum deposit amount                                                                                  |             |
| depositStatus         | true     | string    | deposit status                                                                                          | allowed, prohibited |
| minWithdrawAmt        | true     | string    | minimum withdrawal amount                                                                               |             |
| maxWithdrawAmt        | true     | string    | single maximum withdrawal amount                                                                        |             |
| withdrawQuotaPerDay   | true     | string    | Daily withdrawal quota (Singapore time zone)                                                            |             |
| withdrawQuotaPerYear  | true     | string    | withdrawal quota for the year                                                                           |             |
| withdrawQuotaTotal    | true     | string    | total withdrawal quota                                                                                  |             |
| withdrawPrecision     | true     | int       | withdrawal precision                                                                                    |             |
| withdrawFeeType       | true     | string    | Withdrawal fee type (the type of withdrawal fee for a specific currency on a specific chain is unique) | fixed, circulated, ratio |
| transactFeeWithdraw   | false    | string    | single withdrawal fee (only valid for fixed type, withdrawFeeType=fixed)                               |             |
| minTransactFeeWithdraw| false    | string    | Minimum single withdrawal fee (only valid for interval type and ratio type with lower limit, withdrawFeeType=circulated or ratio) |             |
| maxTransactFeeWithdraw| false    | string    | Maximum single withdrawal fee (only valid for interval type and ratio type with upper limit, withdrawFeeType=circulated or ratio) |             |
| transactFeeRateWithdraw| false   | string    | transaction fee rate for a single withdrawal (only valid for ratio type, withdrawFeeType=ratio)       |             |
| withdrawStatus        | true     | string    | withdrawal status                                                                                       | allowed, prohibited |
| instStatus            | true     | string    | currency status                                                                                         | normal, delisted |


### status code

| Status Code | Error Message                        | Error Scenario Description |
|-------------|--------------------------------------|----------------------------|
| 200         | success                              | Request succeeded          |
| 500         | error                                | System error               |
| 2002        | invalid field value in "field name" | Illegal field value        |


## Get the current system timestamp

This interface returns the current system timestamp, that is, the total **milliseconds** from **UTC** January 1, 1970 0:00:00:00 milliseconds to the present.

```shell
curl "https://api.bitv.com/v1/common/timestamp"
```

### HTTP requests

- GET `/v1/common/timestamp`

### Request parameters

This interface does not accept any parameters.

> Response:

```json
   "data": 1494900087029
```

# market data

## Introduction

The market data interface provides market data such as various K-lines, depth and latest transaction records.

The following are the error codes, error messages and descriptions returned by the market data interface.

| Error Code         | Error Message                | Description                              |
| ------------------ | ---------------------------- | ---------------------------------------- |
| invalid-parameter  | invalid symbol               | Invalid trading pair                      |
| invalid-parameter  | invalid period               | Incorrect period parameter for K-line request |
| invalid-parameter  | invalid depth                | Incorrect depth parameter                 |
| invalid-parameter  | invalid type                 | Depth type parameter error                |
| invalid-parameter  | invalid size                 | Incorrect size parameter                  |
| invalid-parameter  | invalid size, valid range: [1, 2000] | Incorrect size parameter, valid range: [1, 2000] |
| invalid-parameter  | request timeout              | Request timeout                           |



## K-line data (candle chart)

This interface returns historical K-line data.

```shell
curl "https://api.bitv.com/market/history/kline?period=1day&size=200&symbol=btcusdt"
```

### HTTP requests

- GET `/market/history/kline`

### Request parameters
| parameter | data type | required | default value | description | value range |
| --------- | --------- | -------- | ------------- | ----------- | ----------- |
| symbol    | string    | true     | NA            | Trading pair | btcusdt, ethbtc, etc. |
| period    | string    | true     | NA            | Return data time granularity, i.e., the time interval of each candle | 1min, 5min, 15min, 30min, 60min, 4hour, 1day, 1mon, 1week, 1year |
| size      | integer   | false    | 150           | Number of K-line data to return | [1, 2000] |


<aside class="notice">The current REST API does not support custom time intervals. If you need historical fixed time range data, please refer to the K-line interface in the Websocket API. </aside>
<aside class="notice">When obtaining hb10 net worth, please fill in "hb10" for symbol. </aside>
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
     "high": 1940.0000,
     "vol": 71031537.97866500
   }
]
```

### Response data
| Field Name | Data Type | Description |
| ---------- | --------- | ----------- |
| id         | long      | The timestamp adjusted to Singapore time, in seconds, used as the id of this candlestick |
| amount     | float     | Transaction amount in base currency |
| count      | integer   | Transaction count |
| open       | float     | Opening price of this candlestick |
| close      | float     | Closing price of this candlestick |
| low        | float     | Lowest price in this candlestick |
| high       | float     | Highest price in this candlestick |
| vol        | float     | Volume in quote currency |


## Aggregation Quotes (Ticker)

This interface obtains ticker information and provides transaction aggregation information in the last 24 hours.

```shell
curl "https://api.bitv.com/market/detail/merged?symbol=ethusdt"
```

### HTTP requests

- GET `/market/detail/merged`

### Request parameters

| Parameter | Data Type | Required | Default Value | Description | Value Range |
| --------- | --------- | -------- | ------------- | ----------- | ----------- |
| symbol    | string    | true     | NA            | Trading pair | btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for value) |


> Response:

```json
{
   "id": 1499225271,
   "ts":1499225271000,
   "close": 1885.0000,
   "open": 1960.0000,
   "high": 1985.0000,
   "low": 1856.0000,
   "amount":81486.2926,
   "count": 42122,
   "vol":157052744.85708200,
   "ask":[1885.0000,21.8804],
   "bid": [1884.0000,1.6702]
}
```

### Response data
| Field Name | Data Type | Description |
| ---------- | --------- | ----------- |
| id         | long      | NA |
| amount     | float     | Transaction volume in base currency (rolling 24 hours) |
| count      | integer   | Number of transactions (rolling 24 hours) |
| open       | float     | Opening price of this stage (rolling 24 hours) |
| close      | float     | The latest price at this stage (rolling 24 hours) |
| low        | float     | The lowest price of this stage (rolling 24 hours) |
| high       | float     | The highest price of this stage (rolling 24 hours) |
| vol        | float     | Volume in quote currency (rolling 24 hours) |
| bid        | object    | Current highest bid price [price, size] |
| ask        | object    | Current minimum ask price [price, size] |


## Latest Tickers for all trading pairs

Get tickers for all trading pairs.

```shell
curl "https://api.bitv.com/market/tickers"
```

<aside class="notice">This interface returns the tickers of all trading pairs, so the amount of data is large. </aside>

### HTTP requests

- GET `/market/tickers`

### Request parameters

This interface does not accept any parameters.

> Response:

```json
[
     {
         "open":0.044297, // opening price
         "close":0.042178, // closing price
         "low":0.040110, // the lowest price
         "high":0.045255, // the highest price
         "amount": 12880.8510,
         "count": 12838,
         "vol":563.0388715740,
         "symbol": "ethbtc",
         "bid":0.007545,
         "bidSize": 0.008,
         "ask":0.008088,
         "askSize": 0.009
     },
     {
         "open": 0.008545,
         "close": 0.008656,
         "low": 0.008088,
         "high": 0.009388,
         "amount":88056.1860,
         "count": 16077,
         "vol":771.7975953754,
         "symbol": "ltcbtc",
         "bid":0.007545,
         "bidSize": 0.008,
         "ask":0.008088,
         "askSize": 0.009
     }
]
```

### Response data

The core response data is an object column, each object contains the following fields

| Field Name | Data Type | Description |
| ---------- | --------- | ----------- |
| amount     | float     | Transaction volume in base currency (rolling 24 hours) |
| count      | integer   | Number of transactions (according to rolling 24 hours) |
| open       | float     | Opening price (calculated in natural days in Singapore time) |
| close      | float     | Latest price (Singapore Time Natural Day) |
| low        | float     | Lowest price (in Singapore time calendar days) |
| high       | float     | Highest price (in Singapore time natural day) |
| vol        | float     | Volume in quote currency (rolling 24 hours) |
| symbol     | string    | Trading pair, such as btcusdt, ethbtc |
| bid        | float     | Buy price |
| bidSize    | float     | Buy quantity |
| ask        | float     | Ask price |
| askSize    | float     | Sell quantity |


## Depth of Market Data

This interface returns the current market depth data for the specified trading pair.

```shell
curl "https://api.bitv.com/market/depth?symbol=btcusdt&type=step2"
```

### HTTP requests

- GET `/market/depth`

### Request parameters
| parameter | data type | required | default value | description | value range |
| --------- | --------- | -------- | ------------- | ------------ | ------------------------------------------- |
| symbol    | string    | true     | NA            | Trading pair | btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for value) |
| depth     | integer   | false    | 20            | Number of depths to return | 5, 10, 20 |
| type      | string    | true     | step0         | Price aggregation level, see details below | step0, step1, step2, step3, step4, step5 |

<aside class="notice">When the type value is 'step0', the default value of 'depth' is 150 instead of 20.</aside>

**Description of each value for parameter type**

| Value  | Description                               |
| ------ | ----------------------------------------- |
| step0  | No aggregation                            |
| step1  | Aggregation level: quote precision * 10    |
| step2  | Aggregation level: quote precision * 100   |
| step3  | Aggregation level: quote precision * 500   |
| step4  | Aggregation level: quote precision * 1000  |


> Response:

```json
{
     "version": 31615842081,
     "ts": 1489464585407,
     "bids": [
       [7964, 0.0678], // [price, size]
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

<aside class="notice">The returned JSON top-level data object is named 'tick' instead of the usual 'data'. </aside>

| Field Name | Data Type | Description |
| ---------- | --------- | ----------- |
| ts         | integer   | Timestamp adjusted to Singapore time, in milliseconds |
| version    | integer   | Internal field |
| bids       | object    | All current bids [price, size] |
| asks       | object    | All current ask orders [price, size] |


## Recent market transaction records

This interface returns the latest transaction record of the specified trading pair.

```shell
curl "https://api.bitv.com/market/trade?symbol=ethusdt"
```

### HTTP requests

- GET `/market/trade`

### Request parameters
| Parameter | Data Type | Required | Default Value | Description |
| --------- | --------- | -------- | ------------- | ----------- |
| symbol    | string    | true     | NA            | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |



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
         "amount": 0.0122,
         "direction": "buy",
         "ts": 1489464451000
       }
     ]
}
```

### Response data

<aside class="notice">The returned JSON top-level data object is named 'tick' instead of the usual 'data'. </aside>

| Field Name | Data Type | Description |
| ---------- | --------- | ----------- |
| id         | integer   | unique transaction id (will be discarded) |
| trade-id   | integer   | unique transaction ID (NEW) |
| amount     | float     | transaction amount in base currency |
| price      | float     | transaction price in quote currency |
| ts         | integer   | Timestamp adjusted to Singapore time, in milliseconds |
| direction  | string    | Transaction direction: "buy" or "sell", "buy" means to buy, "sell" means to sell |

## Get recent transaction records

This interface returns all recent transaction records of the specified trading pair.

```shell
curl "https://api.bitv.com/market/history/trade?symbol=ethusdt&size=2"
```

### HTTP requests

- GET `/market/history/trade`

### Request parameters
| parameter | data type | required | default value | description |
| --------- | --------- | -------- | ------------- | ----------- |
| symbol    | string    | true     | NA            | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |
| size      | integer   | false    | 1             | the number of transaction records to return, the maximum value is 2000 |

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
             "id":3161878751418918529341,
             "price": 94.6900000000000000000,
             "direction": "sell"
          },
          {
             "amount":73.771000000000000000,
             "ts":1544390317905,
             "trade-id": 102043483473
             "id":3161878751418918532514,
             "price": 94.6600000000000000000,
             "direction": "sell"
          }
       ]
    },
    {
       "id":31618776989,
       "ts":1544390311353,
       "data":[
          {
             "amount": 1.0000000000000000000,
             "ts":1544390311353,
             "trade-id": 102043494568,
             "id":3161877698918918522622,
             "price":94.710000000000000000,
             "direction": "buy"
          }
       ]
    }
]
```

### Response data

<aside class="notice">The returned data object is an array of objects, and each array element is all transaction records under a timestamp (in milliseconds) adjusted to Singapore time, and these transaction records are presented in the form of an array. </aside>

| Parameter | Data Type | Description |
| --------- | -------- | --------------------------- |
| id | integer | unique transaction id (will be discarded) |
| trade-id | integer | unique transaction ID (NEW) |
| amount | float | transaction amount in base currency |
| price | float | transaction price in quote currency |
| ts | integer | Timestamp adjusted to Singapore time, in milliseconds |
| direction | string | Transaction direction: "buy" or "sell", "buy" means to buy, "sell" means to sell |


## Last 24 hours market data

This interface returns the summary of market data in the last 24 hours.

```shell
curl "https://api.bitv.com/market/detail?symbol=ethusdt"
```

### HTTP requests

- GET `/market/detail`

### Request parameters

| Parameter | Data Type | Required | Default Value | Description |
| --------- | -------- | -------- | ------------- | ----------- |
| symbol | string | true | NA | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |


> Response:

```json
{
    "amount":613071.438479561,
    "open":86.21,
    "close": 94.35,
    "high": 98.7,
    "id": 31619471534,
    "count": 138909,
    "low": 84.63,
    "version":31619471534,
    "vol":5.6617373443873316E7
}
```

### Response data

<aside class="notice">The returned JSON top-level data object is named 'tick' instead of the usual 'data'. </aside>

| Field Name | Data Type | Description |
| ---------- | --------- | ----------- |
| id | integer | Response ID |
| amount | float | Transaction volume in base currency (rolling 24 hours) |
| count | integer | Number of transactions (according to rolling 24 hours) |
| open | float | Opening price of this stage (according to rolling 24 hours) |
| close | float | Closing price of this stage (according to rolling 24 hours) |
| low | float | Lowest price of this stage (according to rolling 24 hours) |
| high | float | Highest price of this stage (according to rolling 24 hours) |
| vol | float | Volume in quote currency (rolling 24 hours) |
| version | integer | Internal data |


# Account related

## Introduction

The account-related interface provides functions such as account, balance, history query and asset transfer.

<aside class="notice">Access to account-related interfaces requires signature authentication. </aside>

The following are the error codes, error messages and descriptions returned by account-related interfaces.

| Error Code | Error Message | Description |
| ---------- | ------------- | ----------- |
| 500 | system error | Exception in calling internal service |
| 1002 | forbidden | Forbidden operation, such as inconsistency between accountId and UID in user input parameters |
| 2002 | "invalid field value in `currency`" | Currency does not conform to regular rules ^[a-z0-9]{2,10}$ |
| 2002 | "invalid field value in `transactTypes`" | The change type transactTypes is not "transfer" |
| 2002 | "invalid field value in `sort`" | Pagination request parameter is not valid "asc" or "desc" |
| 2002 | "value in `fromId` is not found in record" | fromId not found |
| 2002 | "invalid field value in `accountId`" | accountId in the query parameter is empty |
| 2002 | "value in `startTime` exceeded valid range" | The query time parameter is greater than the current time or more than 180 days from the current time |
| 2002 | "value in `endTime` exceeded valid range" | The query end time is less than the start time or the query time span is greater than 10 days |


## account information 

API Key Permission: Read<br>
Frequency limit value (NEW): 100 times/2s

Query all account ID `account-id` and related information of the current user

### HTTP requests

- GET `/v1/account/accounts`

### Request parameters

none

> Response:

```json
{
   "data": [
     {
       "id": 100001,
       "type": "spot",
       "subtype": "",
       "state": "working"
     }
   ]
}
```

### Response data
| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------- | ----------- |
| id | true | long | account-id | |
| state | true | string | account status | working: normal, lock: account is locked |
| type | true | string | account type | spot: spot account |


## Account Balance

API Key Permission: Read<br>
Frequency limit value (NEW): 100 times/2s

Query the balance of the specified account, the following accounts are supported:

spot: spot account

### HTTP requests

- GET `/v1/account/accounts/{account-id}/balance`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| -------------- | -------- | ---- | ----------- | ------------- | ----------- |
| account-id | true | string | account-id, fill in the path, value reference `GET /v1/account/accounts` | | |


> Response:

```json
{
   "data": {
     "id": 100009,
     "type": "spot",
     "state": "working",
     "list": [
       {
         "currency": "usdt",
         "type": "trade",
         "balance": "5007.4362872650"
       },
       {
         "currency": "usdt",
         "type": "frozen",
         "balance": "348.1199920000"
       }
     ]
   }
}
```

### Response data
| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------- | ----------- |
| id | true | long | Account ID | |
| state | true | string | Account status | working: normal, lock: account is locked |
| type | true | string | Account type | spot: spot account |
| list | false | Array | | |

**list** field description:

| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------- | ----------- |
| balance | true | string | Balance | |
| currency | true | string | Currency | |
| type | true | string | Type | trade: trade balance, frozen: frozen balance |


## Get account asset valuation

API Key permission: read

Frequency limit value (NEW): 100 times/2s

According to BTC or fiat currency denomination unit, obtain the total asset valuation of the specified account.

### HTTP requests

- GET `/v2/account/asset-valuation`

### Request parameters


| Parameter          | Required | Data Type | Description                                                                                                      | Default Value | Value Range                                         |
| ------------------ | -------- | --------- | ---------------------------------------------------------------------------------------------------------------- | ------------- | --------------------------------------------------- |
| accountType        | true     | string    | The type of the account                                                                                          | NA            | spot: spot account                                  |
| valuationCurrency  | false    | string    | The fiat currency used for asset valuation                                                                       | BTC           | Available legal currencies: BTC, USD (case sensitive) |
| subUid             | false    | long      | The UID of the sub-user. If not provided, the account asset valuation of the user associated with the API key is returned | NA            |                                                     |


> Responses:

```json
{
     "code": 200,
     "data": {
         "balance": "34.75",
         "timestamp": 1594901254363
     },
     "ok": true
}
```

### return fields

| Parameter | Required | Data Type | Description                                                |
| --------- | -------- | --------- | ---------------------------------------------------------- |
| balance   | true     | string    | Total asset valuation based on a certain fiat currency      |
| timestamp | true     | long      | Data return time, represented in Unix time (milliseconds)   |



## Asset transfer

API Key Permissions: Transaction<br>

This node is a general interface for asset transfer between parent users and sub-users. <br>

Features supported only by the parent user include:<br>
1. The transfer between the currency account of the parent user and the currency account of the sub-user;<br>
2. Transfer between currency accounts of different sub-users;<br>

Only sub-user supported features include:<br>
1. To transfer the currency account of the sub-user to the currency account of other sub-users under the parent user, this permission is disabled by default and requires the authorization of the parent user. The authorization interface is `POST /v2/sub-user/transferability`;<br>
2. Transfer from the currency account of the sub-user to the currency account of the parent user;<br>

Other transfer functions will be launched gradually, so stay tuned. <br>

### HTTP requests

- POST `/v1/account/transfer`

### Request parameters

| Parameter          | Required | Data Type | Description                                    | Value Range                          |
| ------------------ | -------- | --------- | ---------------------------------------------- | ------------------------------------ |
| from-user          | true     | long      | Transfer-out user UID                          | Parent user UID, Child user UID       |
| from-account-type  | true     | string    | Transfer-out account type                      | spot                                 |
| from-account       | true     | long      | Transfer account ID                            |                                      |
| to-user            | true     | long      | Transfer-in user UID                           | Parent user UID, Child user UID       |
| to-account-type    | true     | string    | Transfer to account type                       | spot                                 |
| to-account         | true     | long      | Transfer to account ID                         |                                      |
| currency           | true     | string    | Currency                                       | Value reference GET /v1/common/currencys |
| amount             | true     | string    | Transfer amount                                |                                      |



> Response:

```json
{
     "status": "ok",
     "data": {
         "transact-id": 220521190,
         "transact-time": 1590662591832
     }
}
```

### Response data

| Parameter        | Required | Data Type | Description              | Value Range |
| ---------------- | -------- | --------- | ------------------------ | ----------- |
| status           | true     | string    | Status                   | "ok" or "error" |
| data             | true     | list      |                          |             |
| { transact-id    | true     | int       | Transaction serial number |             |
| transact-time }  | true     | long      | Transaction time         |             |



## Account History

API Key Permission: Read<br>
Frequency limit value (NEW): 5 times/2s

This node returns the account history based on the user account ID.

###HTTP Request

- GET `/v1/account/history`

### Request parameters

| Parameter Name | Required | Data Type | Description | Default Value | Value Range |
| -------------- | -------- | --------- | ----------- | ------------- | ----------- |
| account-id     | true     | string    | Account number, refer to `GET /v1/account/accounts` |               |             |
| currency       | false    | string    | Currency, e.g., btc, ltc, bch, eth, etc... (refer to `GET /v1/common/currencys` for values) |               |             |
| transact-types | false    | string    | Change types, multiple choices separated by commas | all           | trade, transact-fee, fee-deduction, transfer, deposit, withdraw, withdraw-fee, other-types, rebate |
| start-time     | false    | long      | Unix time in milliseconds. Use transact-time as the key to search. The maximum query window is 1 hour. The window translation range is the last 30 days. | ((end-time) - 1 hour) | [(end-time) - 1 hour, end-time] |
| end-time       | false    | long      | Unix time in milliseconds. Use transact-time as the key to search. The maximum query window is 1 hour. The window translation range is the last 30 days. | current-time   | [(current-time) - 29 days, current-time] |
| sort           | false    | string    | Search direction | asc           | asc, desc   |
| size           | false    | int       | Maximum number of entries | 100           | [1, 500]    |
| from-id        | false    | long      | Start number (valid only when querying for the next page) |               |             |


> Response:

```json
{
     "status": "ok",
     "data": [
         {
             "account-id": 5260185,
             "currency": "btc",
             "transact-amt": "0.002393000000000000",
             "transact-type": "transfer",
             "record-id": 89373333576,
             "avail-balance": "0.002393000000000000",
             "acct-balance": "0.002393000000000000",
             "transact-time": 1571393524526
         },
         {
             "account-id": 5260185,
             "currency": "btc",
             "transact-amt": "-0.002393000000000000",
             "transact-type": "transfer",
             "record-id": 89373382631,
             "avail-balance": "0E-18",
             "acct-balance": "0E-18",
             "transact-time": 1571393578496
         }
     ]
}
```

### Response data

| Field Name    | Data Type | Description                                              | Value Range |
| ------------- | --------- | -------------------------------------------------------| ------------|
| status        | string    | Status code                                              |             |
| data          | object    |                                                         |             |
| { account-id  | long      | Account number                                           |             |
| currency      | string    | Currency                                                 |             |
| transact-amt  | string    | Change amount (Positive for deposit or Negative for withdrawal) |             |
| transact-type | string    | Transaction type                                         |             |
| avail-balance | string    | Available balance                                        |             |
| acct-balance  | string    | Account balance                                          |             |
| transact-time | long      | Transaction time (database record time)                  |             |
| record-id }   | long      | Database record ID (globally unique)                     |             |
| next-id       | long      | The start number of the next page (included when the query results need to be returned in pages) |             |


## Financial statement

API Key permission: read

This node returns the financial history based on the user account ID. <br>
For the first phase of the launch, only the query of transfer transaction (“transactType” = “transfer”) is currently supported. <br>
The query window framed by "startTime"/"endTime" is up to 10 days, which means that the range that can be retrieved through a single query is up to 10 days. <br>
The query window can be shifted within the range of the last 180 days, that is, records of the past 180 days can be retrieved at most through multiple shift window queries. <br>

### HTTP Request

- GET `/v2/account/ledger`

### Request parameters
| Parameter Name | Data Type | Required | Description |
| -------------- | --------- | -------- | ----------- |
| accountId      | string    | TRUE     | Account ID |
| currency       | string    | FALSE    | Currency (default: all currencies) |
| transactTypes  | string    | FALSE    | Transact types, multiple choices separated by commas (default: all) Possible values: transfer |
| startTime      | long      | FALSE    | Start time in milliseconds (See Note 1 for value range and default value) |
| endTime        | long      | FALSE    | End time in milliseconds (See Note 2 for value range and default value) |
| sort           | string    | FALSE    | Search direction ('asc' for ascending, 'desc' for descending, default: 'desc') |
| limit          | int       | FALSE    | Maximum number of items returned in a single page [1,500] (default: 100) |
| fromId         | long      | FALSE    | Starting number (only valid when querying on the next page, See Note 3) |


Note 1:<br>
startTime value range: [(endTime - 10 days), endTime], unix time in millisecond<br>
startTime default value: (endTime - 10 days)

Note 2:<br>
endTime value range: [(current time - 180 days), current time], unix time in millisecond<br>
endTime default value: current time

> Response:

```json
{
"code": 200,
"message": "success",
"data": [
     {
         "accountId": 5260185,
         "currency": "btc",
         "transactAmt": 1.0000000000000000000,
         "transactType": "transfer",
         "transferType": "margin-transfer-out",
         "transactId": 0,
         "transactTime": 1585573286913,
         "transferr": 5463409,
         "transferee": 5260185
     },
     {
         "accountId": 5260185,
         "currency": "btc",
         "transactAmt": -1.0000000000000000000,
         "transactType": "transfer",
         "transferType": "margin-transfer-in",
         "transactId": 0,
         "transactTime": 1585573281160,
         "transferr": 5260185,
         "transferee": 5463409
     }
]
}
```

### Response data

| Field Name    | Data Type | Required | Description                                            | Value Range |
| ------------- | --------- | -------- | ------------------------------------------------------ | ----------- |
| code          | integer   | TRUE     | Status code                                            |             |
| message       | string    | FALSE    | Error description (if any)                             |             |
| data          | object    | TRUE     | Order of fields defined in the user request parameter   |             |
| { accountId   | integer   | TRUE     | Account ID                                             |             |
| currency      | string    | TRUE     | Currency                                               |             |
| transactAmt   | number    | TRUE     | Amount of change (Positive for incoming or negative for outgoing) |             |
| transactType  | string    | TRUE     | Transact type                                          | transfer    |
| transferType  | string    | FALSE    | Transfer type (only valid for transactType=transfer)   | master-transfer-in, master-transfer-out, sub-transfer-in, sub-transfer-out |
| transactId    | integer   | TRUE     | Transaction serial number                              |             |
| transactTime  | integer   | TRUE     | Transaction time                                       |             |


# Wallet (deposit and withdrawal related)

## Introduction

The interface related to deposit and withdrawal provides functions such as deposit address, withdrawal address, withdrawal amount, deposit and withdrawal records, etc., as well as functions such as withdrawal and cancellation of withdrawal.

<aside class="notice">Signature authentication is required to access the interfaces related to deposit and withdrawal. </aside>

The following are the return codes, return messages and instructions returned by the relevant interfaces of deposit and withdrawal.

| Return Code | Return Message                    | Description                           |
| ----------- | -------------------------------- | ------------------------------------- |
| 200         | success                          | Request succeeded                     |
| 500         | error                            | System error                          |
| 1002        | unauthorized                     | Unauthorized                          |
| 1003        | invalid signature                | Signature verification failed         |
| 2002        | invalid field value in "field name" | Illegal field value                   |
| 2003        | missing mandatory field "field name" | Mandatory field missing               |


## Deposit Address Query

This node is used to query the deposit address of a specific currency (except IOTA) in its blockchain, and both parent and child users are available

API Key Permission: Read<br>
Frequency limit value (NEW): 20 times/2s

<aside class="notice"> IOTA coins are not supported for deposit address query </aside>

```shell
curl "https://api.bitv.com/v2/account/deposit/address?currency=btc"
```

### HTTP requests

- GET `/v2/account/deposit/address`

### Request parameters

| Field Name | Required | Type   | Field Description | Value Range                               |
| ---------- | -------- | ------ | ----------------- | ----------------------------------------- |
| currency   | true     | string | Currency          | btc, ltc, bch, eth, etc ... (value reference `GET /v1/common/currencys`) |


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

### Response data

| Field Name  | Required | Data Type | Field Description                     | Value Range                                              |
| ----------- | -------- | --------- | ------------------------------------ | ------------------------------------------------------- |
| code        | true     | int       | Status code                           |                                                         |
| message     | false    | string    | Error description (if any)            |                                                         |
| data        | true     | object    |                                       |                                                         |
| { currency  | true     | string    | Currency                              |                                                         |
|   address   | true     | string    | Deposit address                       |                                                         |
|   addressTag| true     | string    | Deposit address tag                   |                                                         |
|   chain }   | true     | string    | Chain name                            |                                                         |

### Status Code

| Status Code | Error Message                  | Error Scenario Description                                |
| ----------- | ----------------------------- | -------------------------------------------------------- |
| 200         | success                       | Request succeeded                                        |
| 500         | error                         | System error                                             |
| 1002        | unauthorized                  | Unauthorized                                             |
| 1003        | invalid signature             | Signature verification failed                            |
| 2002        | invalid field value in "field name" | Illegal field value                                      |
| 2003        | missing mandatory field "field name" | Mandatory field missing                                 |


## Withdrawal limit query

This node is used to query the withdrawal amount of each currency, and it is only available to parent users

API Key Permission: Read<br>
Frequency limit value (NEW): 20 times/2s

```shell
curl "https://api.bitv.com/v2/account/withdraw/quota?currency=btc"
```

### HTTP requests

- GET `/v2/account/withdraw/quota`

### Request parameters

| Field Name | Required | Data Type | Field Description | Value Range                                      |
| ---------- | -------- | --------- | ---------------- | ----------------------------------------------- |
| currency   | true     | string    | Currency          | btc, ltc, bch, eth, etc ... (value reference `GET /v1/common/currencys`) |


> Response:

```json
{
     "code": 200,
     "data":
         {
             "currency": "btc",
             "chains": [
                 {
                     "chain": "btc",
                     "maxWithdrawAmt": "200.00000000",
                     "withdrawQuotaPerDay": "200.00000000",
                     "remainWithdrawQuotaPerDay": "200.000000000000000000",
                     "withdrawQuotaPerYear": "700000.00000000",
                     "remainWithdrawQuotaPerYear": "700000.000000000000000000",
                     "withdrawQuotaTotal": "7000000.00000000",
                     "remainWithdrawQuotaTotal": "7000000.000000000000000000"
                 }
         }
     ]
}
```

### Response data

| Field Name                  | Required | Data Type | Field Description                 | Value Range                                                                                     |
| -------------------------- | -------- | --------- | --------------------------------- | ---------------------------------------------------------------------------------------------- |
| code                       | true     | int       | Status code                       |                                                                                                  |
| message                    | false    | string    | Error description (if any)        |                                                                                                  |
| data                       | true     | object    |                                   |                                                                                                  |
| currency                   | true     | string    | Currency                          | btc, ltc, bch, eth, etc ... (value reference `GET /v1/common/currencys`)                       |
| chains                     | true     | object    |                                   |                                                                                                  |
| { chain                    | true     | string    | Chain name                        |                                                                                                  |
| maxWithdrawAmt             | true     | string    | Single maximum withdrawal amount  |                                                                                                  |
| withdrawQuotaPerDay        | true     | string    | Daily withdrawal quota            |                                                                                                  |
| remainWithdrawQuotaPerDay  | true     | string    | Remaining withdrawal quota for the day  |                                                                                              |
| withdrawQuotaPerYear       | true     | string    | Withdrawal quota for the year     |                                                                                                  |
| remainWithdrawQuotaPerYear | true     | string    | Remaining withdrawal quota for the year  |                                                                                              |
| withdrawQuotaTotal         | true     | string    | Total withdrawal quota            |                                                                                                  |
| remainWithdrawQuotaTotal   | true     | string    | Remaining withdrawal quota        |                                                                                                  |

### Status Code

| Status Code | Error Message                     | Error Scenario Description                   |
| ----------- | --------------------------------- | ------------------------------------------- |
| 200         | success                           | Request succeeded                            |
| 500         | error                             | System error                                 |
| 1002        | unauthorized                      | Unauthorized                                 |
| 1003        | invalid signature                 | Signature verification failed                |
| 2002        | invalid field value in "field name" | Illegal field value                          |

## Withdraw address query

API Key Permission: Read<br>

This node is used to query the withdrawal addresses available for the API key, and is only available to parent users. <br>

### HTTP requests

- GET `/v2/account/withdraw/address`

### Request parameters

| Parameter name | Required | Type   | Description                                                    | Default value | Value range                                              |
| -------------- | -------- | ------ | -------------------------------------------------------------- | ------------- | -------------------------------------------------------- |
| currency       | true     | string | Currency                                                       |               | btc, ltc, bch, eth, etc ... (Refer to `GET /v1/common/currencys`) |
| chain          | false    | string | Chain name                                                      |               | If not filled, return the withdrawal addresses of all chains |
| note           | false    | string | Address note                                                   |               | If not filled, return all note withdrawal addresses      |
| limit          | false    | int    | Maximum number of items returned in a single page               | 100           | [1, 500]                                                 |
| fromId         | false    | long   | Starting number (withdrawal address ID, valid for pagination)   | NA            |                                                          |


> Response:

```json
{
     "code": 200,
     "data": [
         {
             "currency": "usdt",
             "chain": "usdt",
             "note": "Binance",
             "addressTag": "",
             "address": "15PrEcqTJRn4haLeby3gJJebtyf4KgWmSd"
         }
     ]
}
```

### Response data

| Parameter name | Required | Data type | Description                                                    | Value range |
| -------------- | -------- | --------- | -------------------------------------------------------------- | ----------- |
| code           | true     | int       | Status code                                                     |             |
| message        | false    | string    | Error description (if any)                                      |             |
| data           | true     | object    |                                                                |             |
| { currency     | true     | string    | Currency                                                        |             |
| chain          | true     | string    | Chain name                                                       |             |
| note           | true     | string    | Address note                                                    |             |
| addressTag     | false    | string    | Address tag, if any                                             |             |
| address }      | true     | string    | Address                                                         |             |
| nextId         | false    | long      | Starting number of the next page (withdrawal address ID)        |             |

Remarks:<br>
The server returns the "nextId" field only when the data item requested by the user exceeds the single-page limit (set by the "limit" field). After the user receives the "nextId" returned by the server –<br>
1) It must be known that there are still data that cannot be returned on this page;<br>
2) If you need to continue to query the next page of data, you should request the query again and use the "nextId" returned by the server as "fromId", and keep other request parameters unchanged. <br>
3) As the database record ID, "nextId" and "fromId" have no other business meaning except for page turning query. <br>


## Virtual currency withdrawal

This node is used to withdraw the digital currency of the spot account to the blockchain address (which already exists in the currency withdrawal address list) without multiple (SMS, email) verification, and is only available to mother users

API Key Permission: Withdrawal<br>
Frequency limit value (NEW): 20 times/2s

<aside class="notice">If the user has set priority to use the fast withdrawal channel in the personal settings </a>, the withdrawal initiated through the API will also give priority to the fast withdrawal channel. Quick coin withdrawal means that when the target address of the coin withdrawal is the internal user address of the platform, the coin withdrawal will go through the fast channel inside the platform instead of the blockchain. </aside>
<aside class="notice">API withdrawal only supports the addresses in the user withdrawal address list</a>. The IOTA one-time withdrawal address cannot be set as a common address, so IOTA withdrawal through API is not supported. </aside>

### HTTP requests

- POST `/v1/dw/withdraw/api/create`

> Request:

```json
{
   "address": "0xde709f2102306220921060314715629080e2fb77",
   "amount": "0.05",
   "currency": "eth",
   "fee": "0.01"
}
```

### Request parameters

| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------------------------------------------------- | ----------- |
| address        | true     | string    | Withdrawal address | Only supports addresses in the corresponding currency address list on the official website |
| amount         | true     | string    | Withdrawal amount | |
| currency       | true     | string    | Asset type | btc, ltc, bch, eth, etc ... (Refer to `GET /v1/common/currencys`) |
| fee            | true     | string    | Transfer fee | |
| chain          | false    | string    | Value reference `GET /v2/reference/currencies`. For example, when withdrawing USDT to OMNI, this parameter must be set to "usdt". When withdrawing USDT to TRX, this parameter must be set to "trc20usdt". For other currencies, this parameter does not need to be set. | |
| addr-tag       | false    | string    | Virtual currency shared address tag, suitable for xrp, xem, bts, steem, eos, xmr | Integer string format, e.g., "123" |

> Response:

```json
{
   "data": 700
}
```

### Response data

| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------- | ----------- |
| data           | false    | long      | Withdrawal ID |             |


## Cancel withdrawal

This node is used to cancel the submitted withdrawal request and is only available to parent users

API Key Permission: Withdrawal<br>
Frequency limit value (NEW): 20 times/2s

### HTTP requests

- POST ` /v1/dw/withdraw-virtual/{withdraw-id}/cancel`

### Request parameters

| Parameter name | Required | Type | Description |
| -------------- | -------- | ---- | ----------- |
| withdraw-id   | true     | long | Withdrawal ID (to be filled in the path) |



> Response:

```json
{
   "data": 700
}
```

### Response data


| Parameter name | Required | Data type | Description |
| -------------- | -------- | --------- | ----------- |
| data           | false    | long      | Withdrawal ID |


## Deposit and withdrawal record

This node is used to query deposit and withdrawal records, both parent and child users are available

API Key Permission: Read<br>
Frequency limit value (NEW): 20 times/2s

### HTTP requests

- GET `/v1/query/deposit-withdraw`

### Request parameters
| Parameter name | Required | Data type | Description | Default value | Value range |
| -------------- | -------- | --------- | ----------- | ------------- | ----------- |
| currency       | false    | string    | Currency    |               | btc, ltc, bch, eth, etc ... (Refer to `GET /v1/common/currencys`) |
| type           | true     | string    | Recharge or withdrawal |             | deposit or withdraw, sub-users can only deposit |
| from           | false    | string    | Query starting ID | By default, the default value is direct. When direct is 'prev', from is 1, return from old to new in ascending order; when direct is 'next', from is the ID of the latest record, and return from new to old in descending order | |
| size           | false    | string    | Query record size | 100           | 1-500 |
| direct         | false    | string    | Return record sorting direction | default       | "prev" (ascending) or "next" (descending) |


> Response:

```json
{
   "data":
     [
       {
         "id": 1171,
         "type": "deposit",
         "currency": "xrp",
         "tx-hash": "ed03094b84eafbe4bc16e7ef766ee959885ee5bcb265872baaa9c64e1cf86c2b",
         "amount": 7.457467,
         "address": "rae93V8d2mdoUQHwBDBdM4NHCMehRJAsbm",
         "address-tag": "100040",
         "fee": 0,
         "state": "safe",
         "created-at": 1510912472199,
         "updated-at": 1511145876575
       },
       ...
     ]
}
```

### Response data
| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------- | ----------- |
| id             | true     | long      | Deposit order ID | |
| type           | true     | string    | Type | 'deposit', 'withdraw', deposit only for sub-users |
| currency       | true     | string    | Currency | |
| tx-hash        | true     | string    | Transaction hash | |
| chain          | true     | string    | Chain name | |
| amount         | true     | float     | Amount | |
| address        | true     | string    | Destination address | |
| address-tag    | true     | string    | Address tag | |
| fee            | true     | float     | Handling fee | |
| state          | true     | string    | State | See table below |
| error-code     | false    | string    | Withdrawal failure error code, only applicable when type is "withdraw" and state is "reject", "wallet-reject", or "failed" | |
| error-msg      | false    | string    | Withdrawal failure error message, only applicable when type is "withdraw" and state is "reject", "wallet-reject", or "failed" | |
| created-at     | true     | long      | Creation time | |
| updated-at     | true     | long      | Last updated time | |

- Definition of virtual currency deposit status:

| Status   | Description   |
| -------- | ------------- |
| unknown  | Status unknown |
| confirming  | Confirming |
| confirmed | Confirmed |
| safe | Completed |
| orphan | To be confirmed |

- Definition of virtual currency withdrawal status:

| Status        | Description       |
| -------------- | ----------------- |
| verifying      | Pending verification |
| failed            | Authentication failed |
| submitted     | Submitted |
| reexamine    | Under review |
| canceled       | Canceled |
| pass              | Approved |
| reject           | Approval rejected |
| pre-transfer   | Processing |
| wallet-transfer | Sent |
| wallet-reject   | Wallet reject |
| confirmed    | Block confirmed |
| confirm-error   | Block confirmation error |
| repealed         | Revoked |

# Sub-user management

## Introduction

The sub-user management interface provides functions such as creation, query, permission setting, and transfer of sub-users, creation, modification, query, and deletion of API Keys for sub-users, and query of sub-user deposit and withdrawal addresses and balances.

<aside class="notice">Signature authentication is required to access related interfaces of sub-user management. </aside>

The following are the return codes, return messages, and descriptions returned by sub-user-related interfaces.
| Error code | Return message | Description |
| ---------- | -------------- | ----------- |
| 1002 | "forbidden" | Forbidden operations, such as the account not being allowed to create sub-users |
| 1003 | "unauthorized" | Unauthenticated |
| 2002 | Invalid field value | Parameter error |
| 2014 | Number of sub-accounts in the request exceeded valid range | The number of sub-accounts has reached the limit |
| 2014 | Number of API keys in the request exceeded valid range | The number of API keys exceeds the limit |
| 2016 | Invalid request while value specified in sub-user states | Freeze/thaw failure |



## Sub-user creation

This interface is used by the parent user to create sub-users, up to 50 at a time

API Key Permissions: Transactions

### HTTP requests

- POST `/v2/sub-user/creation`

> Request:

```json
{
"userList":
   [
     {
       "userName": "test123",
       "note": "123"
     },
     {
       "userName": "test456",
       "note": "123"
     }
   ]
}
```

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| -------------- | -------- | ---- | ----------- | ------------- | ----------- |
| userList | true | object | | | |
| [{ userName | true | string | Sub-username, an important identification of sub-user identity, requires uniqueness within the platform | NA | A combination of 6 to 20 letters and numbers, which can be pure letters; if a combination of letters and numbers, it needs to start with a letter; letters are not case-sensitive; |
| note }] | false | string | Sub-user note, no uniqueness requirement | NA | Up to 20 characters, unlimited character types |


> Response:

```json
{
     "code": 200,
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

### Response data
| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | -------- | ----------- | ----------- |
| code | true | int | Status code | |
| message | false | string | Error description (if any) | |
| data | true | object | | |
| [{ userName | true | string | Sub-username | |
| note | false | string | Sub-user notes (only valid for sub-users with notes) | |
| uid | false | long | Sub-user UID (only valid for successfully created sub-users) | |
| errCode | false | string | Creation failure error code (only valid for sub-users that failed to be created) | |
| errMessage }] | false | string | Error reason for failed creation (only valid for sub-users that failed to be created) | |

## Get the list of sub-users

Through this interface, the parent user can obtain the UID list of all sub-users and the status of each user

API Key permission: read

### HTTP requests

- GET `/v2/sub-user/user-list`

### Request parameters

| Parameter name | Required | Data type | Description | Default value | Value range |
| -------------- | -------- | --------- | ----------- | ------------- | ----------- |
| fromId | false | long | Query starting number (valid for pagination queries) | | |


> Response:

```json
{
     "code": 200,
     "data": [
         {
             "uid": 63628520,
             "userState": "normal"
         },
         {
             "uid": 132208121,
             "userState": "normal"
         }
     ]
}
```

### Response data

| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------- | --------------- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| { uid | true | long | subuser UID | |
| userState } | true | string | subuser state | lock, normal |
| nextId | false | long | starting number for the next page query (included only when there is next page data) | |


## Freeze/Unfreeze sub-users

API Key Permissions: Transaction<br>
Frequency limit value (NEW): 20 times/2s

This interface is used by the parent user to freeze and unfreeze the next sub-user

###HTTP requests

- POST `/v2/sub-user/management`

### Request parameters

| Parameter | Required | Data Type | Length | Description | Value Range |
| --------- | -------- | --------- | ------ | ----------- | ----------- |
| subUid | true | long | - | UID of the sub-user | - |
| action | true | string | - | Operation type | lock (freeze), unlock (unfreeze) |


> Response:

```json
{
   "code": 200,
"data": {
      "subUid": 12902150,
      "userState": "lock"}
}
```

### Response data

| Parameter | Required | Data Type | Length | Description | Value Range |
| --------- | -------- | --------- | ------ | ----------- | ----------- |
| subUid | true | long | - | Sub-user UID | - |
| userState | true | string | - | Sub-user state | lock (frozen), normal (normal) |



## Get the user status of a specific sub-user

The parent user can obtain the user status of a specific sub-user through this interface

API Key permission: read

### HTTP requests

- GET `/v2/sub-user/user-state`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| -------------- | -------- | ---- | ----------- | ------------- | ------------ |
| subUid         | TRUE     | long | Sub-user UID |               |              |

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
| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------- | ----------- |
| code           | TRUE     | int       | status code |             |
| message        | FALSE    | string    | error description (if any) | |
| data           | TRUE     | object    |             |             |
| { uid          | TRUE     | long      | subuser UID |             |
| userState      | TRUE     | string    | Sub-user state | lock, normal |


##Set sub-user transaction permissions

API Key Permissions: Transactions

This interface is used by the parent user to set the transaction permissions of sub-users in batches.
The sub-user's spot trading authority is enabled by default and does not need to be set.

###HTTP requests

- POST `/v2/sub-user/tradable-market`

### Request parameters

| Parameter   | Required | Data Type | Length | Description                                    | Value Range                            |
| ----------- | -------- | --------- | ------ | ---------------------------------------------- | -------------------------------------- |
| subUids     | true     | string    | -      | Sub-user UID list (multiple filling is supported, up to 50, separated by commas) | -                                      |
| accountType | true     | string    | -      | Account type                                   | isolated-margin, cross-margin           |
| activation  | true     | string    | -      | Account activation status                      | activated, deactivated                  |

> Response:

```json
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
```

### Response data

| Parameter    | Required | Data Type | Length | Description                                                             | Value Range                    |
| ------------ | -------- | --------- | ------ | ----------------------------------------------------------------------- | ------------------------------ |
| code         | true     | int       | -      | Status code                                                             |                                |
| message      | false    | string    | -      | Error description (if any)                                              |                                |
| data         | true     | object    | -      |                                                                        |                                |
| {subUid      | true     | string    | -      | Sub-user UID                                                            |                                |
| accountType  | true     | string    | -      | Account type                                                            | isolated-margin, cross-margin  |
| activation   | true     | string    | -      | Account activation status                                               | activated, deactivated         |
| errCode      | false    | int       | -      | Request rejected error code (returned only when the subUid permission is incorrect) |                                |
| errMessage}  | false    | string    | -      | Request rejected error message (returned only when the subUid permission is incorrect) |                                |


## Set sub-user asset transfer permission

API Key Permissions: Transactions

This interface is used by the parent user to set the asset transfer permissions of sub-users in batches.
Sub-user's fund transfer authority includes:

- Transfer from a sub-user's spot account to another sub-user's spot account under the same parent user;
- Transfer from the sub-user spot account to the parent user's spot account (no setting is required, it is enabled by default).

###HTTP requests

- POST `/v2/sub-user/transferability`

### Request parameters
| Parameter     | Required | Data Type | Length | Description                                                          | Value Range                     |
| ------------- | -------- | --------- | ------ | -------------------------------------------------------------------- | ------------------------------- |
| subUids       | true     | string    | -      | Sub-user UID list (multiple values are supported, up to 50)          | -                               |
| accountType   | false    | string    | -      | Account type (default value is "spot" if not filled)                  | spot                            |
| transferrable | true     | bool      | -      | Transferrable indicator                                              | true, false                     |


> Response:

```json
{
     "code": 200,
     "data": [
         {
             "accountType": "spot",
             "transferrable": true,
             "subUid": 13220823
         }
     ]
}
```

### Response data
| Parameter     | Required | Data Type | Length | Description                                                          | Value Range                     |
| ------------- | -------- | --------- | ------ | -------------------------------------------------------------------- | ------------------------------- |
| code          | true     | int       | -      | Status code                                                          |                                 |
| message       | false    | string    | -      | Error description (if any)                                           |                                 |
| data          | true     | object    | -      | Data                                                                 |                                 |
| {subUid       | true     | long      | -      | Sub-user UID                                                         | -                               |
| accountType   | true     | string    | -      | Account type                                                         | spot                            |
| transferrable | true     | bool      | -      | Transferrable indicator                                              | true, false                     |
| errCode       | false    | int       | -      | Request rejected error code (returned only when market access error) |                                 |
| errMessage}   | false    | string    | -      | Request rejected error message (returned only when market access error)|                                 |

## Get a list of accounts for a specific subuser

Through this interface, the parent user can obtain the Account ID list and the status of each account of a specific sub-user

API Key permission: read

### HTTP requests

- GET `/v2/sub-user/account-list`

### Request parameters
| Parameter name | Required | Type | Description | Default value | Value range |
| -------------- | -------- | ---- | ----------- | ------------- | ----------- |
| subUid         | TRUE     | long | Sub-user UID |               |             |


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
                     }
                 ]
             }
         ]
     }
}
```

### Response data

| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------- | ----------- |
| code | TRUE | int | Status code | |
| message | FALSE | string | Error description (if any) | |
| data | TRUE | object | | |
| { uid | TRUE | long | Subuser UID | |
| list | TRUE | object | | |
| { accountType | TRUE | string | Account type | spot, futures, swap |
| activation | TRUE | string | Account activation status | activated, deactivated |
| transferrable | FALSE | bool | Transferable permission (only valid for accountType=spot) | true, false |
| accountIds | FALSE | object | | |
| { accountId | TRUE | string | Account ID | |
| subType | FALSE | string | Account subtype (only valid for accountType=isolated-margin) | |
| accountStatus }}} | TRUE | string | Account status | normal, locked |

## Sub-user API key creation

This interface is used by the parent user to create the API key of the sub-user

API Key Permissions: Transactions

### HTTP requests

- POST `/v2/sub-user/api-key-generation`

### Request parameters

| Parameter name | Required | Type   | Description                                                                                           | Default value | Value range                                                     |
| -------------- | -------- | ------ | ----------------------------------------------------------------------------------------------------- | ------------- | --------------------------------------------------------------- |
| otpToken       | true     | string | Google verification code of the parent user, the parent user must enable GA secondary verification   | NA            | 6 characters, pure numbers                                      |
| subUid         | true     | long   | Sub-user UID                                                                                          | NA            | -                                                               |
| note           | true     | string | API key note                                                                                          | NA            | Up to 255 characters, unlimited character types                  |
| permission     | true     | string | API key permission                                                                                    | NA            | Value range: readOnly, trade. Separate multiple permissions with a comma. |
| ipAddresses    | false    | string | The IPv4/IPv6 host address or IPv4 network address bound to the API key                               | NA            | Up to 20 IP addresses, separated by commas. If no IP address is bound, the API key is only valid for 90 days. |


> Response:

```json
{
     "code": 200,
     "data": {
         "accessKey": "2b55df29-vf25treb80-1535713d-8aea2",
         "secretKey": "c405c550-6fa0583b-fb4bc38e-d317e",
         "note": "62924133",
         "permission": "trade, readOnly",
         "ipAddresses": "1.1.1.1,1.1.1.2"
     }
}
```
### Response data
| Parameter name | Required | Data type | Description                              | Value range |
| -------------- | -------- | --------- | ---------------------------------------- | ----------- |
| code           | true     | int       | Status code                              |             |
| message        | false    | string    | Error description (if any)               |             |
| data           | true     | object    |                                          |             |
| { note         | true     | string    | API key note                             |             |
| accessKey      | true     | string    | Access key                               |             |
| secretKey      | true     | string    | Secret key                               |             |
| permission     | true     | string    | API key permission                       |             |
| ipAddresses    | false    | string    | IP address bound to the API key          |             |


## Parent-child user API key information query

This interface is used for the parent user to query its own API key information, and the parent user to query the API key information of sub-users

API Key permission: read

### HTTP requests

- GET `/v2/user/api-key`

### Request parameters

| Parameter name | Required | Type   | Description                                                          | Default value | Value range |
| -------------- | -------- | ------ | -------------------------------------------------------------------- | ------------- | ----------- |
| uid            | true     | long   | Parent user UID, child user UID                                       | NA            |             |
| accessKey      | false    | string | The access key of the API key. If not specified, returns all API keys | NA            |             |


> Response:

```json
{
     "code": 200,
     "message": "success",
     "data": [
         {
             "accessKey": "4ba5cdf2-4a92c5da-718ba144-dbuqg6hkte",
             "status": "normal",
             "note": "62924133",
             "permission": "readOnly, trade",
             "ipAddresses": "1.1.1.1,1.1.1.2",
             "validDays": -1,
             "createTime": 1591348751000,
             "updateTime": 1591348751000
         }
     ]
}
```
### Response data
| Parameter name | Required | Data type | Description                              | Value range                      |
| -------------- | -------- | --------- | ---------------------------------------- | -------------------------------- |
| code           | true     | int       | Status code                              |                                  |
| message        | false    | string    | Error description (if any)               |                                  |
| data           | true     | object    |                                          |                                  |
| [{             |          |           |                                          |                                  |
| accessKey      | true     | string    | Access key                               |                                  |
| note           | true     | string    | API key note                             |                                  |
| permission     | true     | string    | API key permission                       |                                  |
| ipAddresses    | false    | string    | IP address bound to the API key          |                                  |
| validDays      | true     | int       | Remaining valid days of the API key      | If -1, it means permanent validity |
| status         | true     | string    | Current status of the API key            | normal (normal), expired (expired) |
| createTime     | true     | long      | Creation time of the API key             |                                  |
| updateTime     | true     | long      | Last modification time of the API key    |                                  |


## Modify sub-user API key

This interface is used by the parent user to modify the API key of the child user

API Key Permissions: Transactions

### HTTP requests

- POST `/v2/sub-user/api-key-modification`

### Request parameters

| Parameter name | Required | Type   | Description                                  | Default value | Value range                                                                                                                  |
| -------------- | -------- | ------ | -------------------------------------------- | ------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| subUid         | true     | long   | UID of the sub-user                           | NA            |                                                                                                                              |
| accessKey      | true     | string | Access key of the sub-user's API key          | NA            |                                                                                                                              |
| note           | false    | string | API key note                                 | NA            | Up to 255 characters                                                                                                         |
| permission     | false    | string | API key permission                           | NA            | Value range: readOnly, trade. readOnly must be passed, while trade is optional. The two values are separated by a comma.     |
| ipAddresses    | false    | string | IP address(es) bound to the API key           | NA            | IPv4/IPv6 host address or IPv4 network address. Up to 20 IP addresses can be bound, separated by commas. No default value. If no IP address is bound, the API key is valid for 90 days. |


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
| Parameter name | Required | Data type | Description                     | Value range |
| -------------- | -------- | --------- | ------------------------------- | ----------- |
| code           | true     | int       | Status code                     |             |
| message        | false    | string    | Error description (if any)      |             |
| data           | true     | object    |                                 |             |
| { note         | false    | string    | API key note                    |             |
| permission     | false    | string    | API key permission              |             |
| ipAddresses    | false    | string    | IP address bound to the API key |             |


## Delete sub-user API key

This interface is used by the parent user to delete the API key of the sub-user

API Key Permissions: Transactions

### HTTP requests

- POST `/v2/sub-user/api-key-deletion`

### Request parameters

| Parameter name | Required | Type  | Description                    | Default value | Value range |
| -------------- | -------- | ------| ------------------------------ | ------------- | ----------- |
| subUid         | true     | long  | UID of the sub-user             | NA            |             |
| accessKey      | true     | string| Access key of sub-user API key  | NA            |             |


> Response:

```json
{
     "code": 200,
     "data": null
}
```

### Response data

| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------- | ----------- |
| code           | true     | int       | Status code |             |
| message        | false    | string    | Error description (if any) |             |


## Asset transfer (between parent and child users)

API Key Permissions: Transaction<br>
Frequency limit value (NEW): 2 times/2s

The parent user executes the transfer between the parent and child users

### HTTP requests

- POST `/v1/subuser/transfer`

### Request parameters

| Parameter | Required | Data Type | Description | Value Range |
| --------- | -------- | --------- | ----------- | ----------- |
| sub-uid | true | long | Sub-UID | - |
| currency | true | string | Currency | btc, ltc, bch, eth, etc ... (Refer to `GET /v1/common/currencys` for valid values) |
| amount | true | decimal | Transfer amount | - |
| type | true | string | Transfer type | master-transfer-in (Sub-user transfers virtual currency to parent user) / master-transfer-out (Master user transfers virtual currency to sub-user) |

> Response:

```json
{
   "data": 123456,
   "status": "ok"
}
```

### Response data

| Parameter | Required | Data Type | Length | Description | Value Range |
| --------- | -------- | --------- | ------ | ----------- | ------------ |
| data | true | int | - | Transfer order ID | - |
| status | true | - | - | Status | "OK" or "Error" |

### Error Codes

| Error Code | Description | Type |
| ----------------------------- | ----------------------------- | ---- |
| account-transfer-balance-insufficient-error | Insufficient account balance | string |
| base-operation-forbidden | Forbidden operation (parent-child user relationship error) | string |


## Sub-user deposit address query

This node is used by the parent user to query the deposit address of the sub-user's specific currency (except IOTA) in its blockchain, and it is only available to the parent user

API Key permission: read

### HTTP requests

- GET `/v2/sub-user/deposit-address`

### Request parameters

| Field Name | Required | Type | Description | Default Value | Value Range |
| ---------- | -------- | ---- | ----------- | ------------- | ----------- |
| subUid | true | long | Sub-user UID | NA | Only 1 |
| currency | true | string | Currency | NA | btc, ltc, bch, eth, etc ... (refer to `GET /v1/common/currencys`) |

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

### Response data

| Field Name | Required | Data Type | Field Description | Value Range |
| ---------- | -------- | --------- | ---------------- | ----------- |
| code | true | int | Status code | |
| message | false | string | Error description (if any) | |
| data | true | object | - | |
| { currency | true | string | Currency | |
| address | true | string | Deposit address | |
| addressTag | true | string | Deposit address tag | |
| chain } | true | string | Chain name | |



## Sub-user deposit record query

This node is used by the parent user to query the recharge records of sub-users, and is only available to the parent user

API Key permission: read

### HTTP requests

- GET `/v2/sub-user/query-deposit`

### Request parameters

| Parameter Name | Data Type | Required | Description |
| -------------- | --------- | -------- | ----------- |
| subUid | long | true | Sub-user UID (limited to 1) |
| currency | string | false | Currency. If not provided, returns deposits for all currencies |
| startTime | long | false | Start time in Unix timestamp (milliseconds). Retrieves deposits created after this time |
| endTime | long | false | End time in Unix timestamp (milliseconds). Retrieves deposits created before this time |
| sort | string | false | Sort direction. "asc" for ascending order (from far to near), "desc" for descending order (from near to far). Default value is "desc" |
| limit | int | false | Maximum number of items to be returned in a single page. Default is 100. Must be between 1 and 500 |
| fromId | long | false | Initial deposit order ID. Only valid when querying the next page of results |


Note 1:<br>
startTime value range: [(endTime - 30 days), endTime]<br>
startTime default value: (endTime - 30 days)<br>

Note 2:<br>
endTime value range: unlimited<br>
endTime default value: current time<br>

Note 3:<br>
The server returns the "nextId" field only if the data entries in the time range requested by the user exceed the single page limit (set by the "limit" field). After the user receives the "nextId" returned by the server –<br>
1) It must be known that there are still data that cannot be returned on this page;<br>
2) If you need to continue to query the next page of data, you should request the query again and use the "nextId" returned by the server as "fromId", and keep other request parameters unchanged. <br>
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
             "amount": 0.001000000000000000,
             "address": "LUuuPs5C5Ph3cZz76ZLN1AMLSstqG5PbAz",
             "state": "safe",
             "txHash": "847601d249861da56022323514870ddb96456ec9579526233d53e690264605a7",
             "addressTag": "",
             "createTime": 1587033225787,
             "updateTime": 1587033716616
         }
     ]
}
```

### Response data

| Parameter name | Required | Data type | Description | Value range |
| -------------- | -------- | --------- | ----------- | ----------- |
| code | true | int | Status code | |
| message | false | string | Error description (if any) | |
| data | true | object | | |
| { id | true | long | Deposit order ID | |
| currency | true | string | Currency | |
| txHash | true | string | Transaction hash | |
| chain | true | string | Chain name | |
| amount | true | bigdecimal | Deposit amount | |
| address | true | string | Deposit address | |
| addressTag | true | string | Deposit address tag | |
| state | true | string | Deposit status | See table below |
| createTime | true | long | Creation time | |
| updateTime } | true | long | Last update time | |
| nextId | false | long | Starting number for the next page (ID of the deposit order). Included only when there are more pages of results | |

- Definition of deposit status:

| Status | Description |
| ------ | ----------- |
| unknown | Unknown status |
| confirming | Confirming |
| confirmed | Confirmed |
| safe | Completed |
| orphan | To be confirmed |


## Sub-user balance (summary)

API Key Permission: Read<br>
Frequency limit value (NEW): 2 times/2s

The parent user queries the summary balance of each currency of all sub-users under it

### HTTP requests

- GET `/v1/subuser/aggregate-balance`

### Request parameters

none

> Response:

```json
{
   "status": "ok",
   "data": [
       {
         "currency": "eos",
         "type": "spot",
         "balance": "1954559.809500000000000000"
       },
       {
         "currency": "btc",
         "type": "spot",
         "balance": "0.0000000000000000000"
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
### Response data
| Parameter | Required | Data Type | Length | Description | Value Range |
| --------- | -------- | --------- | ------ | ----------- | ----------- |
| status | true | - | - | Status | "OK" or "Error" |
| data | true | list | - | - | - |

- data

| Parameter | Required | Data Type | Length | Description | Value Range |
| --------- | -------- | --------- | ------ | ----------- | ----------- |
| currency | true | string | - | Currency | - |
| type | true | string | - | Account type | "spot" for spot account |
| balance | true | string | - | Account balance (sum of available balance and frozen balance) | - |


## Sub-user balance

API Key Permission: Read<br>
Frequency limit value (NEW): 20 times/2s

The parent user queries the balance of each currency account of the sub-user

### HTTP requests

- GET `/v1/account/accounts/{sub-uid}`

### Request parameters

| Parameter | Required | Data Type | Length | Description | Value Range |
| --------- | -------- | --------- | ------ | ----------- | ----------- |
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
       "list": []
     }
]
}
```

### Response data

| Parameter | Required | Data Type | Length | Description | Value Range |
| --------- | -------- | --------- | ------ | ----------- | ----------- |
| id | - | long | - | Sub-user UID | - |
| type | - | string | - | Account type | spot: spot account |
| list | - | object | - | - | - |


- list

| Parameter | Required | Data Type | Length | Description | Value Range |
| --------- | -------- | --------- | ------ | ----------- | ----------- |
| currency | - | string | - | Currency | - |
| type | - | string | - | Account type | trade: trading account, frozen: frozen account |
| balance | - | decimal | - | Account balance | - |


# Spot Trading

## Introduction

The spot trading interface provides functions such as order placement, order cancellation, order query, transaction query, and commission rate query.

<aside class="notice">Signature authentication is required to access transaction-related interfaces. </aside>

| Return Code | Description |
| ----------- | ----------- |
| base-argument-unsupported | A parameter is not supported, please check the parameter |
| base-system-error | System error, if the order is canceled: the order status cannot be found in the cache, the order cannot be canceled; if the order is placed: the order failed to enter the cache, please try again |
| login-required | There is no Signature parameter in the URL or the user cannot be found (the key does not correspond to the account ID, etc.) |
| parameter-required | Take Profit Stop Loss order lacks parameter stop-price or operator |
| base-record-invalid | No data found yet, please try again later |
| order-amount-over-limit | Order quantity over limit |
| base-symbol-trade-disabled | The trading pair is disabled |
| base-operation-forbidden | The user is not in the whitelist or the currency does not allow OTC transactions and other prohibited actions |
| account-get-accounts-inexistent-error | The account does not exist under the user |
| account-account-id-inexistent | The account does not exist |
| order-disabled | The trading pair is suspended and cannot place an order |
| cancel-disabled | The trading pair is suspended and the order cannot be canceled |
| order-invalid-price | The price of the order is illegal (for example, the market price cannot have a price, or the price of the limit order exceeds the market price by 10%) |
| order-accountbalance-error | Insufficient account balance |
| order-limitorder-price-min-error | The selling price cannot be lower than the specified price |
| order-limitorder-price-max-error | The purchase price cannot be higher than the specified price |
| order-limitorder-amount-min-error | The order quantity cannot be lower than the specified quantity |
| order-limitorder-amount-max-error | The order quantity cannot be higher than the specified quantity |
| order-etp-nav-price-min-error | The order price cannot be lower than the specified ratio of net value |
| order-etp-nav-price-max-error | The order price cannot be higher than the specified ratio such as net value |
| order-orderprice-precision-error | Transaction price precision error |
| order-orderamount-precision-error | Transaction amount precision error |
| order-value-min-error | The order transaction amount cannot be lower than the specified amount |
| order-marketorder-amount-min-error | The selling amount cannot be lower than the specified amount |
| order-marketorder-amount-buy-max-error | The market order buy amount cannot be higher than the specified amount |
| order-marketorder-amount-sell-max-error | The sell amount of a market order cannot be higher than the specified amount |
| order-holding-limit-failed | The order exceeds the position limit of the currency |
| order-type-invalid | Invalid order type |
| order-orderstate-error | Order state error |
| order-date-limit-error | The query time cannot exceed the system limit |
| order-source-invalid | Invalid order source |
| order-update-error | Update data error |
| order-user-cancel-forbidden | The order type is IOC and cancellation is not allowed |
| order-price-greater-than-limit | The order price is higher than the order limit price before the opening, please place a new order |
| order-price-less-than-limit | The order price is lower than the order limit price before the opening, please place a new order |
| order-stop-order-hit-trigger | The stop loss order is triggered by the current price |
| market-orders-not-support-during-limit-price-trading | Market orders are not supported for time-limited orders |
| price-exceeds-the-protective-price-during-limit-price-trading | The price exceeds the protective price during the price limit |
| invalid-client-order-id | Client order ID duplicated |
| invalid-interval | Query start and end window settings are wrong |
| invalid-start-date | The query start date contains an invalid value |
| invalid-end-date | The query start date contains an invalid value |
| invalid-start-time | The query start time contains invalid values |
| invalid-end-time | Query start time contains invalid value |
| validation-constraints-required | Specified required parameter is missing |
| not-found | The order does not exist when canceling the order |
| base-not-found | Invalid client order ID canceled too many orders, try again after an hour |

## place an order

API Key Permissions: Transactions
Frequency limit value; 100 times/2s

Send a new order for matching.

### HTTP requests

- POST `/v1/order/orders/place`

> Request:

```json
{
   "account-id": "100009",
   "amount": "10.1",
   "price": "100.1",
   "source": "api",
   "symbol": "ethusdt",
   "type": "buy-limit",
   "client-order-id": "a0001"
}
```

### Request parameters
| Parameter Name | Data Type | Required | Default Value | Description |
| -------------- | --------- | -------- | ------------- | ----------- |
| account-id | string | true | NA | Account ID. Refer to `GET /v1/account/accounts` for valid values. For spot transactions, use the account ID of the 'spot' account. |
| symbol | string | true | NA | Trading pair, such as btcusdt, ethbtc, etc. Refer to `GET /v1/common/symbols` for valid values. |
| type | string | true | NA | Order type, including buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit. See below for descriptions. |
| amount | string | true | NA | Order amount (for market orders, it represents the buying amount) |
| price | string | false | NA | Order price (not applicable for market orders) |
| source | string | false | spot-api | Order source. Use "spot-api" for spot transactions. |
| client-order-id | string | false | NA | User-defined order ID (maximum length of 64 characters, must be unique within 24 hours) |
| stop-price | string | false | NA | Trigger price for stop-loss order |
| operator | string | false | NA | Operator for take profit stop loss order trigger price: gte (greater than or equal to), lte (less than or equal to) |



**buy-limit-maker**

When the "order price" >= "the lowest selling price in the market", after the order is submitted, the system will refuse to accept the order;

When the "order price" < "the lowest selling price in the market", the order will be accepted by the system after the submission is successful.

**sell-limit-maker**

When the "order price" <= "the highest buying price in the market", the system will refuse to accept the order after the order is submitted;

When the "order price" > "the highest buying price in the market", the order will be accepted by the system after the submission is successful.

> Response:

```json
{
   "data": "59378"
}
```

### Response data

The returned master data object is a string corresponding to the order number.

If the client order ID is reused (within 24 hours), the node will return an error message invalid.client.order.id.

## Batch order

API Key Permissions: Transaction<br>
Frequency limit (NEW): 50 times/2s<br>

A batch of up to 10 orders

### HTTP requests

- POST `/v1/order/batch-orders`

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
}
]
```

### Request parameters
| Parameter Name | Data Type | Required | Default Value | Description |
| -------------- | --------- | -------- | ------------- | ----------- |
| account-id | string | true | NA | Account ID. Refer to `GET /v1/account/accounts` for valid values. For spot transactions, use the account ID of the 'spot' account. |
| symbol | string | true | NA | Trading pair, such as btcusdt, ethbtc, etc. Refer to `GET /v1/common/symbols` for valid values. |
| type | string | true | NA | Order type, including buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit. See below for descriptions. |
| amount | string | true | NA | Order amount (for market orders, it represents the buying amount) |
| price | string | false | NA | Order price (not applicable for market orders) |
| source | string | false | spot-api | Order source. Use "spot-api" for spot transactions. |
| client-order-id | string | false | NA | User-defined order ID (maximum length of 64 characters, must be unique within 24 hours) |
| stop-price | string | false | NA | Trigger price for stop-loss order |
| operator | string | false | NA | Operator for take profit stop loss order trigger price: gte (greater than or equal to), lte (less than or equal to) |


**buy-limit-maker**

When the "order price" >= "the lowest selling price in the market", after the order is submitted, the system will refuse to accept the order;

When the "order price" < "the lowest selling price in the market", the order will be accepted by the system after the submission is successful.

**sell-limit-maker**

When the "order price" <= "the highest buying price in the market", the system will refuse to accept the order after the order is submitted;

When the "order price" > "the highest buying price in the market", the order will be accepted by the system after the submission is successful.

> Response:

```json
{
     "status": "ok",
     "data": [
         {
             "order-id": 61713400772,
             "client-order-id": "c1"
         },
         {
             "order-id": 61713400940,
             "client-order-id": "d2"
         }
     ]
}
```

### Response data

| Field Name     | Data Type | Description                                                  |
| -------------- | --------- | ------------------------------------------------------------ |
| [{ order-id    | integer   | Order ID                                                     |
| client-order-id | string    | User-defined order ID (if provided)                           |
| err-code       | string    | Error code for rejected orders (only applicable to rejected orders) |
| err-msg }]     | string    | Error message for rejected orders (only applicable to rejected orders) |


If the client order ID is reused (within 24 hours), the node returns the order ID and client order ID of the previous order.

## Cancel order

API Key Permissions: Transaction<br>
Frequency limit value (NEW): 100 times/2s

This interface sends a request to cancel an order.

<aside class="warning">This interface only submits cancellation requests, and the actual cancellation results need to be confirmed through interfaces such as order status and matching status. </aside>

### HTTP requests

- POST `/v1/order/orders/{order-id}/submitcancel`


### Request parameters

| Parameter name | Required | Data type | Description | Default value | Value range |
| -------------- | -------- | --------- | ----------- | ------------- | ----------- |
| order-id       | true     | string    | Order ID, to be filled in the path |               |             |



> Success response:

```json
{
   "data": "59378"
}
```

### Response data

The returned master data object is a string corresponding to the order number.

### error code

> Failure response:

```json
{
   "status": "error",
   "err-code": "order-orderstate-error",
   "err-msg": "Order status error",
   "order-state":-1 // current order state
}
```

In the returned field list, the possible values of order-state include -

| order-state | Description |
| ----------- | ------------------------------------------------------ |
| -1          | The order was already closed in the distant past          |
| 5           | Partially canceled                                      |
| 6           | Filled                                                  |
| 7           | Canceled                                                |
| 10          | Canceling                                               |


## Cancel order (based on client order ID)

API Key Permissions: Transaction<br>
Frequency limit value (NEW): 100 times/2s

This interface sends a request to cancel an order.

<aside class="warning">This interface only submits cancellation requests, and the actual cancellation results need to be confirmed through interfaces such as order status and matching status. </aside>

### HTTP requests

- POST `/v1/order/orders/submitCancelClientOrder`

> Request:

```json
{
   "client-order-id": "a0001"
}
```

### Request parameters

| Parameter name   | Required | Type   | Description              | Default value | Value range |
| ---------------- | -------- | ------ | ------------------------ | ------------- | ----------- |
| client-order-id  | true     | string | User-defined order number |               |             |



> Response:

```json
{
   "data": "10"
}
```

### Response data

| Field Name | Data Type | Description                              |
| ---------- | --------- | ---------------------------------------- |
| data       | integer   | Order cancellation status code            |

| Status Code | Description                                                     |
| ----------- | --------------------------------------------------------------- |
| -1          | Order was already closed in the long past (order state = canceled, partial-canceled, filled, partial-filled) |
| 0           | client-order-id not found                                       |
| 5           | Partial-canceled                                                |
| 6           | Filled                                                          |
| 7           | Canceled                                                        |
| 10          | Canceling                                                       |


## Query current unfilled orders

API Key Permission: Read<br>
Frequency limit value (NEW): 50 times/2s

Query the orders that have been submitted but have not been fully executed or canceled.

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

### Request parameters

| Parameter Name | Data Type | Required | Default Value | Description |
| -------------- | --------- | -------- | ------------- | ----------- |
| account-id     | string    | true     | NA            | Account ID, refer to `GET /v1/account/accounts` for value. Spot transactions use the account-id of the 'spot' account |
| symbol         | string    | true     | NA            | Trading pair, namely btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for value) |
| side           | string    | false    | both          | Specify to only return orders in one direction, possible values are: buy, sell. By default, both directions are returned. |
| from           | string    | false    |               | Query starting ID |
| direct         | string    | false    |               | Query direction, prev means forward; next means backward (required if the 'from' field is set) |
| size           | int       | false    | 100           | Return the quantity of the order, the maximum value is 500. |


> Response:

```json
{
   "data": [
     {
       "id": 5454937,
       "symbol": "ethusdt",
       "account-id": 30925,
       "amount": "1.0000000000000000000",
       "price": "0.453000000000000000",
       "created-at": 1530604762277,
       "type": "sell-limit",
       "filled-amount": "0.0",
       "filled-cash-amount": "0.0",
       "filled-fees": "0.0",
       "source": "web",
       "state": "submitted"
     }
   ]
}
```

### Response data

| Field Name         | Data Type | Description                                                   |
| ------------------ | --------- | ------------------------------------------------------------- |
| id                 | integer   | Order ID, can be used as the 'from' field for the next page turning query request |
| client-order-id    | string    | User-defined order number (available for all open orders)      |
| symbol             | string    | Trading pair, such as btcusdt, ethbtc                          |
| price              | string    | Transaction price of limit order                              |
| created-at         | int       | Timestamp of order creation adjusted to Singapore time, in milliseconds |
| type               | string    | Order type                                                    |
| filled-amount      | string    | Amount of the filled part of the order                         |
| filled-cash-amount | string    | The total price of the filled portion of the order             |
| filled-fees        | string    | Total transaction fees paid                                   |
| source             | string    | Fill in "api" for spot transactions                           |
| state              | string    | Order status, including submitted, partial-filled, canceling, created |
| stop-price         | string    | Trigger price of stop loss order                              |
| operator           | string    | The trigger price operator for stop loss orders                |


## Cancel orders in batches (open orders)

API Key Permissions: Transaction<br>
Frequency limit value (NEW): 50 times/2s

This interface sends a request to cancel orders in batches.

<aside class="warning">This interface only submits cancellation requests, and the actual cancellation results need to be confirmed through interfaces such as order status and matching status. </aside>

### HTTP requests

- POST `/v1/order/orders/batchCancelOpenOrders`


### Request parameters

| Parameter Name | Required | Type   | Description                                                                                                                                 | Default Value | Value Range   |
| -------------- | -------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------- |
| account-id     | false    | string | Account ID, refer to `GET /v1/account/accounts` for available values. If not provided, orders from all accounts will be returned.            |               |               |
| symbol         | false    | string | List of trading symbols (up to 10 symbols, multiple symbols separated by commas). If not provided, orders for all symbols will be returned. | all           |               |
| side           | false    | string | Trading direction. If not provided, all orders that meet the conditions and have not been executed will be returned.                        |               | "buy" or "sell" |
| size           | false    | int    | Number of records to be returned.                                                                                                           | 100           | [0, 100]      |



> Response:

```json
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

| Parameter Name | Required | Data Type | Description                                                       | Value Range |
| -------------- | -------- | --------- | ----------------------------------------------------------------- | ----------- |
| success-count  | true     | int       | Number of successfully canceled orders                             |             |
| failed-count   | true     | int       | Number of failed orders                                            |             |
| next-id        | true     | long      | Next order ID that meets the cancellation criteria for continuation |             |


## Cancel orders in bulk

API Key Permissions: Transaction<br>
Frequency limit value (NEW): 50 times/2s

This interface sends cancellation requests for multiple orders (based on id) at the same time.

### HTTP requests

- POST `/v1/order/orders/batchcancel`

> Request:

```json
{
   "client-order-ids": [
    "5983466", "5722939", "5721027", "5719487"
   ]
}
```

### Request parameters

| Parameter Name    | Required | Data Type  | Description                                                                                                           | Default Value | Value Range                                        |
| ----------------- | -------- | ---------- | --------------------------------------------------------------------------------------------------------------------- | ------------- | ------------------------------------------------- |
| order-ids         | false    | string[]   | List of order IDs (either `order-ids` or `client-order-ids` must be provided, and the list should not exceed 50 orders) |               | Maximum 50 order IDs at a time                     |
| client-order-ids  | false    | string[]   | List of user-made order numbers (either `order-ids` or `client-order-ids` must be provided, and the list should not exceed 50 orders) |               | Maximum 50 client order IDs at a time              |

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
               "client-order-id": "third"
             }
           ]
     }
}
```

### Response data

| Field Name      | Data Type | Description                                                                                           |
| --------------- | --------- | ----------------------------------------------------------------------------------------------------- |
| success         | string[]  | List of successfully canceled orders (can be order ID list or client order ID list as per user request) |
| failed          | string[]  | List of failed orders (can be order ID list or client order ID list as per user request)               |

Failed order list:

| Field Name      | Data Type | Description                                                                                           |
| --------------- | --------- | ----------------------------------------------------------------------------------------------------- |
| [{ order-id     | string    | Order number (if the user includes order ID when creating an order, this field must also be included) |
| client-order-id | string    | User-made order number (if the user includes client order ID when creating an order, this field must also be included) |
| err-code        | string    | Order rejection error code (only valid for rejected orders)                                           |
| err-msg         | string    | Order rejection error message (only valid for rejected orders)                                        |
| order-state     | string    | Current order state (if applicable)                                                                    |

Possible values for order-state:

| order-state | Description                                                                                          |
| ----------- | ---------------------------------------------------------------------------------------------------- |
| -1          | Order was already closed in the past (order state = canceled, partial-canceled, filled, partial-filled) |
| 5           | Partially canceled                                                                                    |
| 6           | Filled                                                                                                |
| 7           | Canceled                                                                                              |
| 10          | Canceling                                                                                             |

## Query order details

API Key Permission: Read<br>
Frequency limit value (NEW): 50 times/2s

This interface returns the latest status and details of the specified order. Orders created through the API cannot be queried after being canceled for more than 2 hours.

### HTTP requests

- GET `/v1/order/orders/{order-id}`


### Request parameters

| Parameter name | Required | Data Type | Description | Default value | Value range |
| -------------- | -------- | --------- | ----------- | ------------- | ----------- |
| order-id       | true     | string    | Order ID     |               |             |


> Response:

```json
{  
  "data": 
  {
    "id": 59378,
    "symbol": "ethusdt",
    "account-id": 100009,
    "amount": "10.1000000000",
    "price": "100.1000000000",
    "created-at": 1494901162595,
    "type": "buy-limit",
    "field-amount": "10.1000000000",
    "field-cash-amount": "1011.0100000000",
    "field-fees": "0.0202000000",
    "finished-at": 1494901400468,
    "user-id": 1000,
    "source": "api",
    "state": "filled",
    "canceled-at": 0
  }
}
```

### Response data

| Field name         | Required | Data type | Description                                                                                      | Value range                                                                                         |
| ------------------ | -------- | --------- | ------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------- |
| account-id         | true     | long      | Account ID                                                                                       |                                                                                                    |
| amount             | true     | string    | Order quantity                                                                                   |                                                                                                    |
| canceled-at        | false    | long      | Order cancellation time                                                                          |                                                                                                    |
| created-at         | true     | long      | Order creation time                                                                              |                                                                                                    |
| field-amount       | true     | string    | Transaction amount                                                                               |                                                                                                    |
| field-cash-amount  | true     | string    | Total transaction amount                                                                         |                                                                                                    |
| field-fees         | true     | string    | Transaction fee (buy for coins, sell for money)                                                  |                                                                                                    |
| finished-at        | false    | long      | The time when the order becomes finalized, not the transaction time, including the "cancelled" status |                                                                                                    |
| id                 | true     | long      | Order ID                                                                                         |                                                                                                    |
| client-order-id    | false    | string    | User-defined order number (all open orders can return client-order-id (if any); only closed orders within 7 days (based on order creation time)                   |
|                    |          |           | (state <> canceled) Can return client-order-id (if any); Only closed orders (state = canceled) within 24 hours (based on order creation time)                    |
|                    |          |           | can return client-order-id (if any)                                                              |                                                                                                    |
| price              | true     | string    | Order price                                                                                      |                                                                                                    |
| source             | true     | string    | Order source                                                                                     | api                                                                                                |
| state              | true     | string    | Order status                                                                                     | submitted, partial-filled, partially-canceled, filled, canceled, created                            |
| symbol             | true     | string    | Trading pair                                                                                     | btcusdt, ethbtc, rcneth ...                                                                         |
| type               | true     | string    | Order type                                                                                       | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, |
|                    |          |           | sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, |
|                    |          |           | sell-limit-maker, buy-stop-limit, sell-stop-limit                                                 |                                                                                                    |
| stop-price         | false    | string    | Trigger price of stop-loss order                                                                 |                                                                                                    |
| operator           | false    | string    | Stop loss order trigger price operator                                                          | gte,lte                                                                                            |



## Query order details (based on client order ID)

API Key Permission: Read<br>
Frequency limit value (NEW): 50 times/2s

This interface returns the latest order status and details of the specified user-defined order number (within 24 hours). Orders created through the API cannot be queried after being canceled for more than 2 hours.

### HTTP requests

- GET `/v1/order/orders/getClientOrder`

### Request parameters
| Parameter name  | Required | Type   | Description                     | Default value |
| --------------- | -------- | ------ | ------------------------------- | ------------- |
| clientOrderId   | true     | string | User-defined order number        |               |


> Response:

```json
{  
  "data": 
  {
    "id": 59378,
    "symbol": "ethusdt",
    "account-id": 100009,
    "amount": "10.1000000000",
    "price": "100.1000000000",
    "created-at": 1494901162595,
    "type": "buy-limit",
    "field-amount": "10.1000000000",
    "field-cash-amount": "1011.0100000000",
    "field-fees": "0.0202000000",
    "finished-at": 1494901400468,
    "user-id": 1000,
    "source": "api",
    "state": "filled",
    "canceled-at": 0
  }
}
```
### Response data

| Field name         | Required | Data type | Description                                                                                    | Value range |
| ------------------ | -------- | --------- | ---------------------------------------------------------------------------------------------- | ----------- |
| account-id         | true     | long      | Account ID                                                                                     |             |
| amount             | true     | string    | Order quantity                                                                                 |             |
| canceled-at        | false    | long      | Order cancellation time                                                                        |             |
| created-at         | true     | long      | Order creation time                                                                            |             |
| field-amount       | true     | string    | Transaction amount                                                                             |             |
| field-cash-amount  | true     | string    | Total transaction amount                                                                       |             |
| field-fees         | true     | string    | Transaction fee (buy for coins, sell for money)                                                |             |
| finished-at        | false    | long      | The time when the order becomes finalized, including the "cancelled" status                   |             |
| id                 | true     | long      | Order ID                                                                                       |             |
| client-order-id    | false    | string    | User-defined order number (Only orders within 24 hours (based on order creation time) can be queried) |             |
| price              | true     | string    | Order price                                                                                    |             |
| source             | true     | string    | Order source                                                                                   | api         |
| state              | true     | string    | Order status                                                                                   |             |
| symbol             | true     | string    | Trading pair                                                                                   |             |
| type               | true     | string    | Order type                                                                                     |             |
| stop-price         | false    | string    | Trigger price of stop-loss order                                                               |             |
| operator           | false    | string    | Stop loss order trigger price operator                                                        | gte, lte    |


If the client order ID does not exist, the following error message will be returned
{
     "status": "error",
     "err-code": "base-record-invalid",
     "err-msg": "record invalid",
     "data": null
}

## transaction details

API Key Permission: Read<br>
Frequency limit value (NEW): 50 times/2s

This interface returns the transaction details of the specified order.

### HTTP requests

- GET `/v1/order/orders/{order-id}/matchresults`

### Request parameters
| Parameter name | Required | Type  | Description                        | Default value |
| -------------- | -------- | ------| ---------------------------------- | ------------- |
| order-id       | true     | string| Order ID, fill in the path         |               |



> Response:

```json
{  
  "data": [
    {
      "id": 29553,
      "order-id": 59378,
      "match-id": 59335,
      "trade-id": 100282808529,
      "symbol": "ethusdt",
      "type": "buy-limit",
      "source": "api",
      "price": "100.1000000000",
      "filled-amount": "9.1155000000",
      "filled-fees": "0.0182310000",
      "created-at": 1494901400435,
      "role": "maker",
      "filled-points": "0.0",
      "fee-deduct-currency": ""
    }
    ...
  ]
}
```

### Response data

<aside class="notice">The main data object returned is an array of objects, each of which represents a transaction result. </aside>

| Field name         | Required | Data type | Description                                             | Value range  |
| ------------------ | -------- | --------- | ------------------------------------------------------- | ------------ |
| created-at         | true     | long      | Transaction timestamp                                   |              |
| filled-amount      | true     | string    | Filled amount                                           |              |
| filled-fees        | true     | string    | Transaction fee (positive value) or transaction rebate (negative value) |              |
| fee-currency       | true     | string    | Transaction fee or rebate currency                       |              |
| id                 | true     | long      | Order transaction record ID                              |              |
| match-id           | true     | long      | Matching ID                                             |              |
| order-id           | true     | long      | Order ID                                                |              |
| trade-id           | false    | integer   | Unique trade ID                                         |              |
| price              | true     | string    | Transaction price                                       |              |
| source             | true     | string    | Order source                                            | api          |
| symbol             | true     | string    | Trading pair                                            | btcusdt, ethbtc, rcneth, ... |
| type               | true     | string    | Order type                                              | buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| role               | true     | string    | Transaction role                                        | maker, taker |
| filled-points      | true     | string    | Deduction amount                                        |              |
| fee-deduct-currency| true     | string    | Deduction type                                          |              |
| fee-deduct-state   | true     | string    | Deduction status                                        | deduction in progress, deduction completed |


Note: <br>

- The transaction rebate amount in filled-fees may not arrive in real time. <br>

## Search history orders

API Key Permission: Read<br>
Frequency limit value (NEW): 50 times/2s

This interface queries historical orders based on search conditions. Orders created through the API cannot be queried after being canceled for more than 2 hours.

Users can choose to query historical orders by "time range" instead of the original query method of "date range".

- If the user fills in start-time AND/OR end-time to query historical orders, the server will query and return according to the "time range" specified by the user, and ignore the start-date/end-date parameters. The query window size of this method is limited to a maximum of 48 hours, and the window translation range is the last 180 days.

- If the user does not fill in the start-time/end-time parameters, but fills in start-date AND/OR end-date to query historical orders, the server will query and return according to the "date range" specified by the user. The query window size of this method is limited to a maximum of 2 days, and the window translation range is the last 180 days.

- If the user neither fills in the start-time/end-time parameter nor the start-date/end-date parameter, the server will default to the current time as the end-time and return the historical orders within the last 48 hours.

It is recommended that users query historical orders by "time range".


### HTTP requests

- GET `/v1/order/orders`

> Request:

```json
{
   "account-id": "100009",
   "amount": "10.1",
   "price": "100.1",
   "source": "api",
   "symbol": "ethusdt",
   "type": "buy-limit"
}
```

### Request parameters

| Parameter name | Required | Type   | Description                                                                                                           | Default value                            | Value range                                                                                                                                                                                                                                                                                                                                                                                                                 |
| -------------- | -------- | ------ | --------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| symbol         | true     | string | Trading pair                                                                                                          |                                          | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`)                                                                                                                                                                                                                                                                                                                                                             |
| types          | false    | string | Combinations of order types to query, separated by commas                                                              |                                          | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit                                                                                                                                                                  |
| start-time     | false    | long   | Query start time, the time format is UTC time in milliseconds. Query based on order generation time                  | -48h                                     | Value range [((end-time) – 48h), (end-time)], the maximum query window is 48 hours, and the translation range is the nearest for 180 days. The translation range of the query window for historical orders that have been completely canceled is only the last 2 hours (state="canceled").                                                                                                                   |
| end-time       | false    | long   | Query end time, the time format is UTC time in milliseconds. Query based on order generation time                    | present                                  | Value range [(present-179d), present], the maximum query window is 48 hours, the translation range is the last 180 days, and the query window translation range of completely canceled historical orders is only the latest 2 hours (state="canceled").                                                                                                                                                       |
| start-date     | false    | string | Query start date, date format yyyy-mm-dd. Query based on the order generation time                                      | -1d                                      | Value range [((end-date) – 1), (end-date)], the maximum query window is 2 days, and the translation range is the nearest for 180 days. The translation range of the query window for historical orders that have been completely canceled is only the last 2 hours (state="canceled").                                                                                                                         |
| end-date       | false    | string | Query end date, date format yyyy-mm-dd. Query based on order generation time                                          | today                                    | Value range [(today-179), today], the maximum query window is 2 days, the translation range is the last 180 days, and the query window translation range of completely canceled historical orders is only the latest 2 hours (state="canceled").                                                                                                                                                             |
| states         | true     | string | Combination of order states to query, separated by ','.                                                               |                                          |                                                                                                                                                                                                                                                                                                                                                                                                                             |
| from           | false    | string | Query start ID                                                                                                        |                                          | If it is a backward query, it will be assigned the last ID obtained in the last query result; if it is a forward query, it will be assigned the first ID obtained in the last query result.                                                                                                                                                                                                                               |
| direct         | false    | string | Query direction                                                                                                       |                                          | prev forward; next backward                                                                                                                                                                                                                                                                                                                                                                                                |
| size           | false    | string | Query record size                                                                                                     | 100                                      | [1, 100]                                                                                                                                                                                                                                                                                                                                                                                                                   |

> Response:

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
      "field-amount": "10.1000000000",
      "field-cash-amount": "1011.0100000000",
      "field-fees": "0.0202000000",
      "finished-at": 1494901400468,
      "user-id": 1000,
      "source": "api",
      "state": "filled",
      "canceled-at": 0
    }
    ...
  ]
}
```

### Response data

| Parameter name   | Required | Data type | Description                                                                                                                                                                                                                                                                                                                                                                         | Value range                                                                                                                                                        |
| ---------------- | -------- | --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| account-id       | true     | long      | Account ID                                                                                                                                                                                                                                                                                                                                                                           |                                                                                                                                                                    |
| amount           | true     | string    | Order quantity                                                                                                                                                                                                                                                                                                                                                                       |                                                                                                                                                                    |
| canceled-at      | false    | long      | The time when the cancellation request was received                                                                                                                                                                                                                                                                                                                                  |                                                                                                                                                                    |
| created-at       | true     | long      | Order creation time                                                                                                                                                                                                                                                                                                                                                                  |                                                                                                                                                                    |
| field-amount     | true     | string    | Transaction amount                                                                                                                                                                                                                                                                                                                                                                   |                                                                                                                                                                    |
| field-cash-amount | true     | string    | Total transaction amount                                                                                                                                                                                                                                                                                                                                                             |                                                                                                                                                                    |
| field-fees       | true     | string    | Transaction fee (buying is base currency, selling is price currency)                                                                                                                                                                                                                                                                                                                  |                                                                                                                                                                    |
| finished-at      | false    | long      | Last transaction time                                                                                                                                                                                                                                                                                                                                                               |                                                                                                                                                                    |
| id               | true     | long      | Order ID, no order of size, can be used as the 'from' field of the next page turning query request                                                                                                                                                                                                                                                                                  |                                                                                                                                                                    |
| client-order-id  | false    | string    | User-defined order number (all open orders can return 'client-order-id' (if any); only closed orders within 7 days (based on order creation time) (state <> canceled) can return 'client-order-id' (if any); only closed orders (state = canceled) within 24 hours (based on order creation time) can be queried)                                                          |                                                                                                                                                                    |
| price            | true     | string    | Order price                                                                                                                                                                                                                                                                                                                                                                          |                                                                                                                                                                    |
| source           | true     | string    | Order source                                                                                                                                                                                                                                                                                                                                                                         | api                                                                                                |
| state            | true     | string    | Order status                                                                                                                                                                                                                                                                                                                                                                         | submitted, partial-filled, partially-canceled, partially-canceled, filled, canceled, created                                                                    |
| symbol           | true     | string    | Trading pair                                                                                                                                                                                                                                                                                                                                                                         | btcusdt, ethbtc, rcneth ...                                                                         |
| type             | true     | string    | Order type                                                                                                                                                                                                                                                                                                                                                                           | submit-cancel: the order cancellation application has been submitted, buy-market: buy at the market price, sell-market: sell at the market price, buy-limit: buy at the limit price, sell-limit: sell at the limit price, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| stop-price       | false    | string    | Trigger price of stop-loss order                                                                                                                                                                                                                                                                                                                                                    |                                                                                                                                                                    |
| operator         | false    | string    | Stop-loss order trigger price operator                                                                                                                                                                                                                                                                                                                                              | gte, lte                                                                                            |

### Error codes related to start-date and end-date:

| Error code          | Corresponding error scenario                                                                                        |
| ------------------- | -------------------------------------------------------------------------------------------------------------- |
| invalid_interval    | Start date is less than end date; or the time interval between start date and end date is greater than 2 days   |
| invalid_start_date  | Start date is a date 180 days ago; or start date is a date in the future                                         |
| invalid_end_date    | End date is a date 180 days ago; or end date is a date in the future                                             |

## Search historical orders within the last 48 hours

API Key Permission: Read<br>
Frequency limit value (NEW): 20 times/2s

This interface queries historical orders within the last 48 hours based on search criteria. Orders created through the API cannot be queried after being canceled for more than 2 hours.

### HTTP requests

- GET `/v1/order/history`

> Request:

```json
{
    "symbol": "btcusdt",
    "start-time": "1556417645419",
    "end-time": "1556533539282",
    "direct": "prev",
    "size": "10"
}
```

### Request parameters

| Parameter name | Required | Type   | Description                                                                                                              | Default value               | Value range                                                  |
| -------------- | -------- | ------ | ------------------------------------------------------------------------------------------------------------------------ | --------------------------- | ------------------------------------------------------------ |
| symbol         | false    | string | Trading pair                                                                                                             | all                         | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |
| start-time     | false    | long   | Query start time (inclusive)                                                                                             | Time 48 hours ago            | UTC time in milliseconds                                     |
| end-time       | false    | long   | Query end time (inclusive)                                                                                               | Query time                   | UTC time in milliseconds                                     |
| direct         | false    | string | Order query direction (Note: it only works when the total number of retrieved items exceeds the limit of the size field) | next                        | prev (forward), next (backward)                              |
| size           | false    | int    | Number of items returned each time                                                                                        | 100                         | [10, 1000]                                                   |

> Response:

```json
{
    "status": "ok",
    "data": [
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

| Parameter name     | Required | Data type | Description                                                                                                                                                                         | Value range                                                             |
| ------------------ | -------- | --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| account-id         | true     | long      | Account ID                                                                                                                                                                          |                                                                         |
| amount             | true     | string    | Order quantity                                                                                                                                                                      |                                                                         |
| canceled-at        | false    | long      | The time when the cancellation request was received                                                                                                                                  |                                                                         |
| created-at         | true     | long      | Order creation time                                                                                                                                                                 |                                                                         |
| field-amount       | true     | string    | Transaction amount                                                                                                                                                                  |                                                                         |
| field-cash-amount  | true     | string    | Total transaction amount                                                                                                                                                            |                                                                         |
| field-fees         | true     | string    | Transaction fee (buying is base currency, selling is price currency)                                                                                                                |                                                                         |
| finished-at        | false    | long      | Last transaction time                                                                                                                                                               |                                                                         |
| id                 | true     | long      | Order ID, no size order                                                                                                                                                             |                                                                         |
| client-order-id    | false    | string    | User-defined order number (only closed orders (state <> canceled) within 48 hours (based on order creation time) can return client-order-id (if any); only 24 hours (state = canceled) | can be queried)                                                        |
| price              | true     | string    | Order price                                                                                                                                                                         |                                                                         |
| source             | true     | string    | Order source                                                                                                                                                                        | api                                                                     |
| state              | true     | string    | Order status                                                                                                                                                                        | partial-canceled, partially-filled, completely-filled, canceled          |
| symbol             | true     | string    | Trading pair                                                                                                                                                                        | btcusdt, ethbtc, rcneth, etc.                                            |
| stop-price         | false    | string    | Trigger price of stop-loss order                                                                                                                                                    |                                                                         |
| operator           | false    | string    | Stop-loss order trigger price operator                                                                                                                                              | gte, lte                                                                |
| type               | true     | string    | Order type                                                                                                                                                                          | buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, etc. |
| next-time          | false    | long      | Next query start time (valid when the request field "direct" is "prev"), next query end time (valid when the request field "direct" is "next")                                       | UTC time in milliseconds                                                |

## Current and historical transactions

API Key Permission: Read<br>
Frequency limit value (NEW): 20 times/2s

This interface queries current and historical transaction records based on search criteria.

### HTTP requests

- GET `/v1/order/matchresults`


### Request parameters

| Parameter name | Required | Type   | Description                                                 | Default value | Value range                                                                                                                                                        |
| -------------- | -------- | ------ | ----------------------------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| symbol         | true     | string | Trading pair                                                | N/A           | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`)                                                                                                      |
| types          | false    | string | Combination of order types to query, separated by ','        | all           | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker |
| start-date     | false    | string | Query start date (Singapore time zone), date format yyyy-mm-dd | -1d           | Range of values [((end-date) – 1), (end-date)], the maximum query window is 2 days, and the window translation range is the last 61 days.                          |
| end-date       | false    | string | Query end date (Singapore time zone), date format yyyy-mm-dd   | today         | Value range [(today-60), today], the maximum query window is 2 days, and the window translation range is the last 61 days.                                          |
| from           | false    | string | Query start ID                                               | N/A           | If it is a backward query, it will be assigned the last ID (not trade-id) obtained in the last query result; if it is a forward query, it will be assigned the first ID (not trade-id) obtained in the last query result. |
| direct         | false    | string | Query direction                                              | next          | prev (forward), next (backward)                                                                                                                                   |
| size           | false    | string | Query record size                                            | 100           | [1, 500]                                                                                                                                                          |

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
      "fee-deduct-currency": ""
    }
    ...
  ]
}
```

### Response data

<aside class="notice">The main data object returned is an array of objects, each of which represents a transaction result. </aside>

| Parameter name        | Required | Data type | Description                                                                                                                                                                                                                                                            | Value range                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| --------------------- | -------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| created-at            | true     | long      | Transaction timestamp.                                                                                                                                                                                                                                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| filled-amount         | true     | string    | Filled amount.                                                                                                                                                                                                                                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| filled-fees           | true     | string    | Transaction fee (positive value) or transaction rebate (negative value).                                                                                                                                                                                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| fee-currency          | true     | string    | Transaction fee or transaction rebate currency. The transaction fee currency for buy orders is the base currency, and the transaction fee currency for sell orders is the pricing currency. The transaction rebate currency for buy orders is the pricing currency, and the transaction rebate currency for sell orders is the base currency. |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| id                    | true     | long      | Order transaction record ID. It is not the order ID of size and can be used as the "from" field for the next page-turning query request.                                                                                                                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| match-id              | true     | long      | Matching ID.                                                                                                                                                                                                                                                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| order-id              | true     | long      | Order ID.                                                                                                                                                                                                                                                              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| trade-id              | false    | integer   | Unique trade ID.                                                                                                                                                                                                                                                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| price                 | true     | string    | Transaction price.                                                                                                                                                                                                                                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| source                | true     | string    | Order source.                                                                                                                                                                                                                                                          | api                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| symbol                | true     | string    | Trading pair.                                                                                                                                                                                                                                                          | btcusdt, ethbtc, rcneth ...                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| type                  | true     | string    | Order type.                                                                                                                                                                                                                                                            | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit                                                                                                                                                                                                                                                   |
| role                  | true     | string    | Transaction role.                                                                                                                                                                                                                                                      | maker, taker                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| filled-points         | true     | string    | Deduction amount .                                                                                                                                                                                                                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| fee-deduct-currency   | true     | string    | Deduction type.                                                                                                                                                                                                                                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| fee-deduct-state      | true     | string    | Deduction status.                                                                                                                                                                                                                                                      | deduction in progress: ongoing, deduction completed: done                                                                                                                                                                                                                                                                                                                                                                                                                                                |


Note: <br>

- The transaction rebate amount in filled-fees may not arrive in real time;<br>
### start-date, end-date related error codes

| Error code           | Corresponding error scenario                                                                                 |
| -------------------- | --------------------------------------------------------------------------------------------------------- |
| invalid_interval     | The start date is greater than the end date, or the time interval between the start and end dates is > 2 days. |
| invalid_start_date   | The start date is 61 days ago or in the future.                                                            |
| invalid_end_date     | The end date is 61 days ago or in the future.                                                              |



## Get the user's current transaction fee rate

Api users can query the transaction pair rate, and there is a limit of 10 transaction pairs at a time, and the rate of sub-users is consistent with that of the parent user

API Key permission: read

```shell
curl "https://api.bitv.com/v2/reference/transact-fee-rate?symbols=btcusdt,ethusdt,ltcusdt"
```

### HTTP requests

- GET `/v2/reference/transact-fee-rate`

### Request parameters

| Parameter      | Data Type | Required | Default Value | Description                                             | Value Range                                             |
| -------------- | --------- | -------- | ------------- | ------------------------------------------------------- | ------------------------------------------------------- |
| symbols        | string    | true     | NA            | Trading pairs, multiple fields are allowed, separated by commas | btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for values) |



> Response:

```json
{
  "code": "200",
  "data": [
     {
        "symbol": "btcusdt",
        "makerFeeRate":"0.002",
        "takerFeeRate":"0.002",
        "actualMakerRate": "0.002",
        "actualTakerRate":"0.002
     },
     {
        "symbol": "ethusdt",
        "makerFeeRate":"0.002",
        "takerFeeRate":"0.002",
        "actualMakerRate": "0.002",
        "actualTakerRate":"0.002
    },
     {
        "symbol": "ltcusdt",
        "makerFeeRate":"0.002",
        "takerFeeRate":"0.002",
        "actualMakerRate": "0.002",
        "actualTakerRate":"0.002
    }
  ]
}
```
### Response data

| Field Name        | Data Type | Description                                                                 |
| ----------------- | --------- | --------------------------------------------------------------------------- |
| code              | integer   | Status code                                                                 |
| message           | string    | Error description (if any)                                                  |
| data              | object    |                                                                             |
| symbol            | string    | Transaction code                                                            |
| makerFeeRate      | string    | Base fee rate for the passive party. If a transaction fee rebate is applicable, the rebate rate (negative value) will be returned |
| takerFeeRate      | string    | Base fee rate for the active side                                            |
| actualMakerRate   | string    | Fee rate after deduction for the passive party. If no deduction is applicable or deduction is not enabled, the base rate will be returned. If a transaction fee rebate is applicable, the rebate rate (negative value) will be returned |
| actualTakerRate   | string    | Fee rate after deduction for the active party. If no deduction is applicable or deduction is not enabled, the base rate will be returned |


Note: <br>

- If makerFeeRate/actualMakerRate is a positive value, this field means the transaction fee rate;<br>
- If makerFeeRate/actualMakerRate is negative, this field means the transaction rebate rate. <br>


# Websocket market data

## Introduction

### Access URL

**Quotation request address**

**`wss://api.bitv.com/ws`**

### data compression

All data returned by the WebSocket market interface is compressed by GZIP, and the client needs to decompress it after receiving the data.

### Heartbeat message

```json
{"ping": 1492420473027}
```

When the user's Websocket client connects to the Websocket server, the server will periodically (currently set to 5 seconds) send a `ping` message to it and include an integer value.

```json
{"pong": 1492420473027}
```

When the user's Websocket client receives this heartbeat message, it should return a `pong` message containing the same integer value.

<aside class="warning">When the Websocket server sends `ping` messages twice but does not receive any `pong` messages back, the server will actively disconnect from the client. </aside>
### Subscribe to topics

> Sub request:

```json
{
   "sub": "market.btcusdt.kline.1min",
   "id": "id1"
}
```

After successfully establishing a connection to the Websocket server, the Websocket client sends a request to subscribe to a specific topic:

{
   "sub": "topic to sub",
   "id": "id generate by client"
}

> Sub response:

```json
{
   "id": "id1",
   "status": "ok",
   "subbed": "market.btcusdt.kline.1min",
   "ts": 1489474081631
}
```

After successfully subscribing, the Websocket client will receive an acknowledgment.

After that, once the subscribed topic is updated, the Websocket client will receive the update message (push) pushed by the server.

### unsubscribe

> UnSub request:

```json
{
   "unsub": "market.btcusdt.trade.detail",
   "id": "id4"
}
```

The format for unsubscribing is as follows:

{
   "unsub": "topic to unsub",
   "id": "id generate by client"
}

> UnSub response:

```json
{
   "id": "id4",
   "status": "ok",
   "unsubbed": "market.btcusdt.trade.detail",
   "ts": 1494326028889
}
```

Successful unsubscribe confirmation.
### request data

The Websocket server also supports one-time request data (pull).

The format of a one-time request is as follows:

{
   "req": "topic to req",
   "id": "id generate by client"
}

For the specific format of the data returned at one time, see each topic.

### Frequency Limit

Data request (req) frequency limit rules

Every two requests for a single connection cannot be less than 100ms.

### error code

The following are the error codes, error messages and descriptions of the WebSocket market interface.

| Error Code | Error Message                           | Description                             |
| ---------- | --------------------------------------- | --------------------------------------- |
| bad-request | invalid topic                           | Topic error                             |
| bad-request | invalid symbol                          | Symbol error                            |
| bad-request | symbol trade not open now                | The trading pair is not currently open   |
| bad-request | 429 too many request                     | Too many requests                       |
| bad-request | unsub with not subbed topic              | Attempt to unsubscribe from an unsubscribed topic |
| bad-request | not json string                         | Invalid JSON format in the request       |
| 1008       | header required correct cloud-exchange   | Incorrect exchangeCode parameter        |
| bad-request | request timeout                         | Request timeout                         |


## K line data

### Topic Subscription

Once the K-line data is generated, the Websocket server will push it to the client through this subscription topic interface:

`market.$symbol$.kline.$period$`

> Subscription Request

```json
{
   "sub": "market.ethbtc.kline.1min",
   "id": "id1"
}
```
### parameters

| parameter | data type | required | description | value range |
| ------ | -------- | -------- | -------- | --------------------------------------------------------------- |
| symbol | string | true | transaction code | btcusdt, ethbtc...etc. |
| period | string | true | K-line period | 1min, 5min, 15min, 30min, 60min, 4hour, 1day, 1mon, 1week, 1year |


> Response

```json
{
  "id": "id1",
  "status": "ok",
  "subbed": "market.ethbtc.kline.1min",
  "ts": 1489474081631 //system response time
}
```

> Update example

```json
{
  "ch": "market.ethbtc.kline.1min",
  "ts": 1489474082831, //system update time
  "tick": {
    "id": 1489464480,
    "amount": 0.0,
    "count": 0,
    "open": 7962.62,
    "close": 7962.62,
    "low": 7962.62,
    "high": 7962.62,
    "vol": 0.0
  }
}
```
### Data update field list

| Field | Data Type | Description |
| ------ | -------- | ---------------------------------------- |
| id | integer | unix time, also used as K line ID |
| amount | float | volume |
| count | integer | transaction count |
| open | float | opening price |
| close | float | closing price (when the K line is the latest one, it is the latest transaction price) |
| low | float | lowest price |
| high | float | highest price |
| vol | float | transaction volume, ie sum (each transaction price * transaction volume of this transaction) |


### Data Request

To obtain K-line data at one time by request, the following parameters need to be provided additionally:
(Up to 300 items can be returned each time)

```json
{
   "req": "market.$symbol.kline.$period",
   "id": "id generated by client",
   "from": "from time in epoch seconds",
   "to": "to time in epoch seconds"
}
```
| Parameter   | Data Type | Required | Default Value                                     | Description                                             | Value Range                                                    |
| ----------- | --------- | -------- | ------------------------------------------------- | ------------------------------------------------------- | -------------------------------------------------------------- |
| from        | integer   | false    | 1501174800 (2017-07-28T00:00:00+08:00)             | Start time (Epoch time in seconds)                       | [1501174800, 2556115200]                                       |
| to          | integer   | false    | 2556115200 (2050-01-01T00:00:00+08:00)             | End time (Epoch time in seconds)                         | [1501174800, 2556115200] or ($from, 2556115200] if "from" is set |

## Depth of market market data

This topic sends the latest Depth of Market snapshot. The snapshot frequency is 1 time per second.

### Topic Subscription

`market.$symbol.depth.$type`

> Subscribe request

```json
{
   "sub": "market.btcusdt.depth.step0",
   "id": "id1"
}
```

### parameters
| parameter | data type | required | default value | description | value range |
| ------ | -------- | -------- | ------ | ------------ | ------------------------------------------------------ |
| symbol | string | true | NA | transaction symbol | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |
| type | string | true | step0 | merge depth type | step0, step1, step2, step3, step4, step5 |

**"type" merge depth type**
| Value | Description |
| ----- | ------------------------------------ |
| step0 | Do not merge depth |
| step1 | Aggregation level = precision*10 |
| step2 | Aggregation level = precision*100 |
| step3 | Aggregation level = precision*1000 |
| step4 | Aggregation level = precision*10000 |
| step5 | Aggregation level = precision*100000 |

When the type value is 'step0', the default depth is 150 steps;
When the type value is 'step1', 'step2', 'step3', 'step4', 'step5', the default depth is 20 steps.


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
  "ch": "market.htusdt.depth.step0",
  "ts": 1572362902027, //system update time
  "tick": {
    "bids": [
      [3.7721, 344.86],// [price, size]
      [3.7709, 46.66] 
    ],
    "asks": [
      [3.7745, 15.44],
      [3.7746, 70.52]
    ],
    "version": 100434317651,
    "ts": 1572362902012 //quote time
  }
}
```
### Data update field list

<aside class="notice">Display the depth list of buying and selling orders under the 'tick' object</aside>
| Field   | Data Type | Description                              |
| ------- | -------- | ---------------------------------------- |
| bids    | object   | All current bids [price, size]            |
| asks    | object   | All current ask orders [price, size]      |
| version | integer  | Internal field                            |
| ts      | integer  | Timestamp of Singapore time in milliseconds |


<aside class="notice">When symbol is set to "hb10", amount, count, vol are all zero values </aside>

### Data Request

Support data request method to obtain market depth data at one time:

```json
{
   "req": "market.btcusdt.depth.step0",
   "id": "id10"
}
```

## Market depth MBP market data (incremental push)

Users can subscribe to this channel to receive the incremental data push of the latest in-depth market Market By Price (MBP); at the same time, this channel supports users to request full data in the form of req.

**MBP incremental push and MBP full REQ request address**

**`wss://api.bitv.com/feed`**

Suggested downstream data processing methods:<br>
1) Subscribe to incremental data and start caching;<br>
2) Request the full amount of data (equal number of gears) and align with the prevSeqNum in the buffered incremental data according to the seqNum of the full amount of message;<br>
3) Start continuous incremental data reception and calculation, construct and continuously update the MBP order book;<br>
4) The prevSeqNum of each incremental data must be consistent with the seqNum of the previous incremental data, otherwise it means that there is incremental data loss, and the full amount of data must be reacquired and aligned;<br>
5) If the incremental data received includes a new price gear, the price gear must be inserted into the appropriate position in the MBP order book;<br>
6) If the incremental data received includes an existing price gear, but the size is different, the size of the price gear in the MBP order book must be replaced;<br>
7) If the size of a certain price gear in the incremental data is 0, the price gear must be deleted from the MBP order book;<br>
8) If an update of two or more price levels is received in a single piece of incremental data, these price levels must be updated in the MBP order book at the same time. <br>

Currently only supports the push of 5-file/20-file MBP step-by-step increments and 150-file MBP snapshot increments, the difference between the two is -<br>
1) The depth is different;<br>
2) 5 files/20 files are incremental MBP quotations one by one, and 150 files are 100 millisecond timed snapshot incremental MBP quotations;<br>
3) When only one-sided market changes occur in the 5-level/20-level order book, the incremental push only includes unilateral market updates. For example, the push message contains the array of asks, but not the array of bids;<br>

```json
{
    "ch": "market.btcusdt.mbp.5",
    "ts": 1573199608679,
    "tick": {
        "seqNum": 100020146795,
        "prevSeqNum": 100020146794,
        "asks": [
            [645.140000000000000000, 26.755973959140651643]
        ]
    }
}
```

When the 150-level order book only has a unilateral market change, the incremental push includes a bilateral market update, but one side of the market is empty, for example, the push message contains the update of the array asks and also includes an empty array of bids;<br>

```json
{
    "ch":"market.btcusdt.mbp.150",
    "ts":1573199608679,
    "tick":{
        "seqNum":100020146795,
        "prevSeqNum":100020146794,
        "bids":[ ],
        "asks":[
            [645.14,26.75597395914065]
        ]
    }
}

```
In the future, the data behavior of the 150-level incremental push will be consistent with that of the 5-level/20-level increment, that is, when the unilateral market depth changes, the push message will not include the other side's market depth;<br>
4) When the 150 order books have not changed within the 100 millisecond interval, the incremental push contains bids and asks empty arrays;<br>

```json
{
    "ch":"market.zecusdt.mbp.150",
    "ts":1585074391470,
    "tick":{
        "seqNum":100772868478,
        "prevSeqNum":100772868476,
        "bids":[  ],
        "asks":[  ]
    }
}

```
However, the 5-level/20-level MBP is incremented one by one, and no data is pushed when the order book does not change;<br>
In the future, the data behavior of 150 increments will be consistent with that of 5 increments, that is, when the order book has not changed, empty messages will no longer be pushed;<br>
5) Only some trading pairs (btcusdt, ethusdt, xrpusdt, eosusdt, ltcusdt, etcusdt, adausdt, dashusdt, bsvusdt) are supported in the 5-level/20-level incremental market, and 150-level snapshot increments support all trading pairs. <br>

The REQ channel supports the acquisition of full data of 5 files/20 files/150 files. <br>

### Subscribe to incremental push

`market.$symbol.mbp.$levels`

> Sub request

```json
{
   "sub": "market.btcusdt.mbp.5",
   "id": "id1"
}
```

### Request full data

`market.$symbol.mbp.$levels`

> Req request

```json
{
   "req": "market.btcusdt.mbp.5",
   "id": "id2"
}
```
### parameters
| parameter | data type | required | default value | description | value range |
| --------- | --------- | -------- | ------------- | ----------- | ----------- |
| symbol    | string    | true     | NA            | transaction code (wildcards are not supported) | |
| levels    | integer   | true     | NA            | depth level (value: 5, 20, 150) | currently only supports 5 levels, 20 levels, or 150 levels of depth |


> Response (incremental subscription)

```json
{
   "id": "id1",
   "status": "ok",
   "subbed": "market.btcusdt.mbp.5",
   "ts": 1489474081631 //system response time
}
```

> Incremental Update (incremental subscription)

```json
{
"ch": "market.btcusdt.mbp.5",
"ts": 1573199608679, //system update time
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
[650.63, 97.996],
[650.77, 97.465],
[651.23, 83.973],
[651.42, 34.465]
]
}
}
```
### Data update field list
| Field       | Data Type | Description                                          |
| ----------- | --------- | ---------------------------------------------------- |
| seqNum      | integer   | message sequence number                               |
| prevSeqNum  | integer   | sequence number of the previous message               |
| bids        | object    | bids, sorted by price in descending order, ["price","size"] |
| asks        | object    | Ask orders, sorted by price in ascending order, ["price","size"] |


## Market depth MBP market data (full push)

Users can subscribe to this channel to receive the full data push of the latest in-depth market Market By Price (MBP). The push frequency is about once every 100 milliseconds.

### Subscribe to incremental push

`market.$symbol.mbp.refresh.$levels`

> Sub request

```json
{
"sub": "market.btcusdt.mbp.refresh.20",
"id": "id1"
}
```

### parameters
| parameter | data type | required | default value | description | value range |
| --------- | --------- | -------- | ------------- | ------------ | ----------- |
| symbol    | string    | true     | NA            | transaction code (wildcards are not supported) | |
| levels    | integer   | true     | NA            | depth level | 5, 10, 20 |


> Response

```json
{
"id": "id1",
"status": "ok",
"subbed": "market.btcusdt.mbp.refresh.20",
"ts": 1489474081631 //system response time
}
```

> Refresh Update

```json
{
"ch": "market.btcusdt.mbp.refresh.20",
"ts": 1573199608679, //system update time
"tick": {

"seqNum": 100020142010,
"bids": [
[618.37, 71.594], // [price, size]
[423.33, 77.726],
[223.18, 47.997],
[219.34, 24.82],
[210.34, 94.463], ... // omit the remaining 15 files
    ],
"asks": [
[650.59, 14.909733438479636],
[650.63, 97.996],
[650.77, 97.465],
[651.23, 83.973],
[651.42, 34.465], ... // omit the remaining 15 files
]
}
}
```
### Data update field list
| Field  | Data Type | Description                                      |
| ------ | --------- | ------------------------------------------------ |
| seqNum | integer   | message sequence number                          |
| bids   | object    | bids, sorted by price in descending order: ["price","size"] |
| asks   | object    | Ask orders, sorted by price in ascending order: ["price","size"] |


## Buy one sell one tick by tick

When any of the data of the first price of buying, the first amount of buying, the first price of selling, and the first amount of selling changes, this topic will be updated one by one.

### Topic Subscription

`market.$symbol.bbo`

> Subscribe request

```json
{
   "sub": "market.btcusdt.bbo",
   "id": "id1"
}
```

### parameters
| Parameter name | Data Type | Required | Default Value | Description | Value Range |
| -------------- | --------- | -------- | ------------- | ----------- | ----------- |
| symbol         | string    | true     | NA            | Transaction symbol | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |

> Response

```json
{
   "id": "id1",
   "status": "ok",
   "subbed": "market.btcusdt.bbo",
   "ts": 1489474081631 //system response time
}
```

> Update example

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
   }
}
```
### Data update field list
| Field | Data Type | Description |
| ------ | -------- | ------------------ |
| symbol | string | transaction code |
| quoteTime | long | Handicap update time |
| bid | float | buy price |
| bidSize | float | buy quantity |
| ask | float | ask price |
| askSize | float | sell quantity |
| seqId | int | message sequence number |


## transaction details

### Topic Subscription

This topic provides a tick-by-tick breakdown of the latest transactions in the market.

`market.$symbol.trade.detail`

> Subscribe request

```json
{
   "sub": "market.btcusdt.trade.detail",
   "id": "id1"
}
```

### parameters
| Parameter | Data Type | Required | Default Value | Description | Value Range |
| --------- | --------- | -------- | ------------- | ----------- | ----------- |
| symbol | string | true | NA | Transaction symbol | btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for values) |

> Response

```json
{
   "id": "id1",
   "status": "ok",
   "subbed": "market.btcusdt.trade.detail",
   "ts": 1489474081631 //system response time
}
```

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
             }
             // more Trade Detail data here
         ]
   }
}
```
### Data update field list
| Field | Data Type | Description |
| ------ | -------- | ---------------------------------------------- |
| id | integer | Unique transaction ID (will be discarded) |
| tradeId | integer | Unique transaction ID (NEW) |
| amount | float | Volume (buy or sell side) |
| price | float | Transaction price |
| ts | integer | Transaction time (UNIX epoch time in millisecond) |
| direction | string | Active transaction party (order direction of taker): 'buy' or 'sell' |


### Data Request

Support data request method to obtain transaction details data at one time (only up to 300 recent transaction records can be obtained):

```json
{
   "req": "market.btcusdt.trade.detail",
   "id": "id11"
}
```

## Market Overview

### Topic Subscription

This topic provides a snapshot of the latest market overview within 24 hours. The snapshot frequency does not exceed 10 times per second.

`market.$symbol.detail`

> Subscribe request

```json
{
   "sub": "market.btcusdt.detail",
   "id": "id1"
}
```

### parameters
| Parameter | Data Type | Required | Default Value | Description | Value Range |
| --------- | -------- | -------- | ------------- | ----------- | ----------- |
| symbol | string | true | NA | Transaction symbol | btcusdt, ethbtc, etc. (value reference `GET /v1/common/symbols`) |


> Response

```json
{
   "id": "id1",
   "status": "ok",
   "subbed": "market.btcusdt.detail",
   "ts": 1489474081631 //system response time
}
```

> Update example

```json
{
   "ch": "market.btcusdt.detail",
   "ts": 1494496390001, //system update time
   "tick": {
     "amount": 12224.2922,
     "open": 9790.52,
     "close": 10195.00,
     "high": 10300.00,
     "id": 1494496390,
     "count": 15195,
     "low": 9657.00,
     "vol": 121906001.754751
   }
}
```
### Data update field list
| Field | Data Type | Description |
| ------ | -------- | ------------------------ |
| id | integer | Unix time, also used as message ID |
| amount | float | 24-hour trading volume |
| count | integer | Number of transactions in 24 hours |
| open | float | 24-hour opening price |
| close | float | Latest price |
| low | float | 24-hour lowest price |
| high | float | 24-hour highest price |
| vol | float | 24-hour turnover |

### Data Request

Support data request method to obtain market summary data at one time:

```json
{
   "req": "market.btcusdt.detail",
   "id": "id11"
}
```


##


# Websocket assets and orders

## Introduction

### Access URL

**Websocket assets and orders**

**`wss://api.bitv.com/ws/v2`**

### data compression

Data is not GZIP compressed.

### Heartbeat message

When the user's Websocket client connects to the WebSocket server, the server will periodically (currently set to 20 seconds) send a `Ping` message to it and include an integer value as follows:

```json
{
"action": "ping",
"data": {
"ts": 1575537778295
}
}
```

When the user's Websocket client receives this heartbeat message, it should return a `Pong` message containing the same integer value:

```json
{
     "action": "pong",
     "data": {
           "ts": 1575537778295 // Use the ts value in the Ping message
     }
}
```

### Valid values for `action`
| Valid Values | Value Description |
| ---------- | ------------------------------------ |
| sub | Subscription data |
| req | Data request |
| ping, pong | Heartbeat data |
| push | Push data, the data type sent from the server to the client |

### Frequency Limit

This version adopts a multi-dimensional frequency limiting strategy for users. The specific strategy is as follows:

- Limit single connection **effective** requests (including req, sub, unsub, excluding ping/pong and other invalid requests) to **50 times/second** (here the second limit is a sliding window). When this limit is exceeded, a "too many request" error message is returned.
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
         "accessKey": "e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx",
         "signatureMethod": "HmacSHA256",
         "signatureVersion": "2.1",
         "timestamp": "2019-09-01T18:16:16",
         "signature": "4F65x5A2bLyMWVQj3Aqp+B4w+ivaA7n5Oi2SuYtCJ9o="
     }
}

```

After successful authentication, the returned data format is as follows:

```json
{
"action": "req",
"code": 200,
"ch": "auth",
"data": {}
}
```

Parameter Description
| field            | required | data type | description                                                                                       |
| ---------------- | -------- | --------- | ------------------------------------------------------------------------------------------------- |
| action           | true     | string    | Websocket data operation type, the fixed value for authentication is req                         |
| ch               | true     | string    | Request subject, the fixed value for authentication is auth                                      |
| authType         | true     | string    | Authentication type, the fixed value for authentication is api. Note that this parameter is not included in the signature calculation. |
| accessKey        | true     | string    | AccessKey in the API Key you applied for                                                          |
| signatureMethod  | true     | string    | Signature method, the protocol for users to calculate the signature message hash, the fixed value is HmacSHA256 |
| signatureVersion | true     | string    | Signature protocol version, the fixed value is 2.1                                               |
| timestamp        | true     | string    | Timestamp, the time (UTC time) when you make the request. Including this value in the query request helps prevent third parties from intercepting your request. Format: 2017-05-11T16:22:06 (in UTC time zone) |
| signature        | true     | string    | Signature, a computed value used to ensure that the signature is valid and has not been tampered with |



### Signature steps

For the signature steps, you can view them in the [Quick Start - Signature Verification] section.

Note: Data in JSON requests does not need to be URL encoded.

### Subscribe to topics

After successfully establishing a connection with the Websocket server, the Websocket client sends a request like the following to subscribe to a specific topic:

```json
{
"action": "sub",
"ch": "accounts. update"
}
```

If the subscription is successful, the Websocket client will receive the following message:

```json
{
"action": "sub",
"code": 200,
"ch": "accounts. update#0",
"data": {}
}
```

### request data

After successfully establishing the connection to the Websocket server, the Websocket client sends the following request to obtain one-time data:

```json
{
     "action": "req",
     "ch": "topic",
}
```

After the request is successful, the Websocket client will receive the following message:

```json
{
     "action": "req",
     "ch": "topic",
     "code": 200,
     "data": {} // request data body
}
```

### error code

The following are the error codes, error messages, and descriptions of the WebSocket asset and order interfaces.
| Error Code | Error Message        | Description                                                             |
| ---------- | -------------------- | ----------------------------------------------------------------------- |
| 200        | True                 | True returns                                                            |
| 100        | timeout off          | Timeout off                                                             |
| 400        | Bad Request          | Bad request                                                             |
| 404        | Not Found            | Service not found                                                       |
| 429        | Too Many Requests    | Exceeded the maximum number of connections for a single server or exceeded the maximum number of connections for a single IP |
| 500        | System exception     | System error                                                            |
| 2000       | invalid.ip           | Invalid IP                                                              |
| 2001       | invalid.json         | Invalid request JSON                                                    |
| 2001       | invalid.authType     | Signature verification method error                                      |
| 2001       | invalid.action       | Invalid subscription event                                              |
| 2001       | invalid.symbol       | Invalid trading pair                                                    |
| 2001       | invalid.ch           | Invalid subscription                                                    |
| 2001       | invalid.exchange     | Invalid exchange code                                                   |
| 2001       | missing.param.auth   | Missing signature verification parameters                               |
| 2002       | invalid.auth.state   | Authentication failed                                                   |
| 2002       | auth.fail            | Signature verification failed                                           |
| 2003       | query.account.list.error | Failed to query account list                                          |
| 4000       | too.many.request     | Client uplink request frequency limit                                    |
| 4000       | too.many.connection | Number of connections with the same key                                  |



## Subscribe to order updates

API Key permission: read

The update push of the order is triggered by any of the following events:<br>

- Scheduled or tracked order trigger failure event (eventType=trigger)<br>
- Cancellation event before triggering of planning order or tracking order (eventType=deletion)<br>
- Order Creation (eventType=creation)<br>
- Order transaction (eventType=trade)<br>
- Order cancellation (eventType=cancellation)<br>

In the messages pushed by different event types, the list of fields is slightly different. Developers can design the returned data structure in the following two ways:<br>

- Define a data structure that contains all fields and allows some fields to be empty<br>
- Define different data structures, each containing their own fields, and inheriting from a data structure containing common data fields

### Subscribe to topics

`orders#${symbol}`

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
"action": "sub",
"code": 200,
"ch": "orders#btcusdt",
"data": {}
}
```

| Parameter | Data Type | Description |
| ------ | -------- | ------------------------- |
| symbol | string | transaction code (wildcard * is supported) |

### Data update field list

> Update example

```json
{
"action": "push",
"ch": "orders#btcusdt",
"data":
{
"orderSide": "buy",
"lastActTime": 1583853365586,
"clientOrderId": "abc123",
"orderStatus": "rejected",
"symbol": "btcusdt",
"eventType": "trigger",
"errCode": 2002,
"errMessage": "invalid.client.order.id (NT)"
}
}
```
When the planning order/tracking order trigger fails –

| Field         | Data Type | Description                                                                 |
| ------------- | --------- | --------------------------------------------------------------------------- |
| eventType     | string    | Event type, valid value: trigger (this event is only valid for plan order/track order) |
| symbol        | string    | Transaction code                                                             |
| clientOrderId | string    | User-defined order number                                                    |
| orderSide     | string    | Order direction, valid values: buy, sell                                     |
| orderStatus   | string    | Order status, valid value: rejected                                          |
| errCode       | int       | Order trigger failure error code                                             |
| errMessage    | string    | Error message for order trigger failure                                      |
| lastActTime   | long      | Order trigger failure time                                                   |


> Update example

```json
{
"action": "push",
"ch": "orders#btcusdt",
"data":
{
"orderSide": "buy",
"lastActTime": 1583853365586,
"clientOrderId": "abc123",
"orderStatus": "canceled",
"symbol": "btcusdt",
"eventType": "deletion"
}
}
```

When a planning order/tracking order is canceled before triggering –

| Field         | Data Type | Description                                                                 |
| ------------- | --------- | --------------------------------------------------------------------------- |
| eventType     | string    | Event type, valid value: deletion (this event is only valid for plan order/tracking order) |
| symbol        | string    | Transaction code                                                             |
| clientOrderId | string    | User-defined order number                                                    |
| orderSide     | string    | Order direction, valid values: buy, sell                                     |
| orderStatus   | string    | Order status, valid value: canceled                                          |
| lastActTime   | long      | Order cancellation time                                                      |


> Update example

```json
{
"action": "push",
"ch": "orders#btcusdt",
"data":
{
"orderSize": "2.000000000000000000",
"orderCreateTime": 1583853365586,
"accountId": 992701,
"orderPrice": "77.000000000000000000",
"type": "sell-limit",
"orderId": 27163533,
"clientOrderId": "abc123",
"orderStatus": "submitted",
"symbol": "btcusdt",
"eventType": "creation"
}
}

```
When an order is placed –
| Field           | Data Type | Description                                                                 |
| --------------- | --------- | --------------------------------------------------------------------------- |
| eventType       | string    | Event type, valid value: creation                                            |
| symbol          | string    | Transaction code                                                             |
| accountId       | long      | Account ID                                                                   |
| orderId         | long      | Order ID                                                                     |
| clientOrderId   | string    | User-made order number (if any)                                              |
| orderPrice      | string    | Order price                                                                  |
| orderSize       | string    | Order size (invalid for market buy orders)                                   |
| orderValue      | string    | Order amount (only valid for market buy orders)                              |
| type            | string    | Order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell-limit-maker, buy-ioc, sell-ioc |
| orderStatus     | string    | Order status, valid value: submitted                                         |
| orderCreateTime | long      | Order creation time                                                          |

Note: <BR>

- When the take profit and stop loss order has not been triggered, the interface will not push the creation of this order;<br>
- Before the Taker order is completed, the interface will first push its creation event. <br>
- The order type of the stop loss order is no longer the original order type "buy-stop-limit" or "sell-stop-limit", but becomes "buy-limit" or "sell-limit". <BR>

> Update example

```json
{
"action": "push",
"ch": "orders#btcusdt",
"data":
{
"tradePrice": "76.000000000000000000",
"tradeVolume": "1.013157894736842100",
"tradeId": 301,
"tradeTime": 1583854188883,
"aggressor": true,
"remainAmt": "0.000000000000000400000000000000000000",
"orderId": 27163536,
"type": "sell-limit",
"clientOrderId": "abc123",
"orderStatus": "filled",
"symbol": "btcusdt",
"eventType": "trade"
}
}
```

When the order is filled –
| Field       | Data Type | Description                                                                      |
| ------------| --------- | -------------------------------------------------------------------------------- |
| eventType   | string    | Event type, valid value: trade                                                  |
| symbol      | string    | Transaction code                                                                 |
| tradePrice  | string    | Traded price                                                                    |
| tradeVolume | string    | Trade volume                                                                    |
| orderId     | long      | Order ID                                                                         |
| type        | string    | Order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell-limit-maker, buy-ioc, sell-ioc |
| clientOrderId | string  | User-made order number (if any)                                                  |
| tradeId     | long      | Trade ID                                                                         |
| tradeTime   | long      | Trade time                                                                       |
| aggressor   | bool      | Whether to be the active party of the transaction, valid values: true (taker), false (maker) |
| orderStatus | string    | Order status, valid values: partial-filled, filled                               |
| remainAmt   | string    | Unexecuted quantity (buy order at market price is the unexecuted amount)          |

Note: <BR>

- The order type of the stop loss order is no longer the original order type "buy-stop-limit" or "sell-stop-limit", but becomes "buy-limit" or "sell-limit". <BR>
- When a taker order is executed with multiple orders of the counterparty at the same time, each resulting transaction (tradePrice, tradeVolume, tradeTime, tradeId, aggressor) will be pushed separately (instead of combined push). <BR>

> Update example

```json
{
"action": "push",
"ch": "orders#btcusdt",
"data":
{
"lastActTime": 1583853475406,
"remainAmt": "2.000000000000000000",
"orderId": 27163533,
"type": "sell-limit",
"clientOrderId": "abc123",
"orderStatus": "canceled",
"symbol": "btcusdt",
"eventType": "cancellation"
}
}
```

When an order is canceled -
| Field       | Data Type | Description                                                                      |
| ------------| --------- | -------------------------------------------------------------------------------- |
| eventType   | string    | Event type, valid value: cancellation                                             |
| symbol      | string    | Transaction code                                                                 |
| orderId     | long      | Order ID                                                                         |
| type        | string    | Order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell-limit-maker, buy-ioc, sell-ioc |
| clientOrderId | string  | User-made order number (if any)                                                  |
| orderStatus | string    | Order status, valid values: partial-canceled, canceled                            |
| remainAmt   | string    | Unexecuted quantity (buy order at market price is the unexecuted amount)          |
| lastActTime | long      | Last update time of the order                                                     |

Note: <BR>

- The order type of the stop loss order is no longer the original order type "buy-stop-limit" or "sell-stop-limit", but becomes "buy-limit" or "sell-limit". <BR>

## Subscribe to update transactions and cancellations after liquidation

API Key permission: read

Pushed only when the user's order is filled or canceled. Among them, the order transaction is pushed one by one. If a taker order is executed with multiple maker orders at the same time, this interface will push the update one by one. However, the order of these transaction messages received by the user may not be completely consistent with the actual order of transactions. In addition, if the execution and cancellation of an order occur almost at the same time, for example, the remaining part of an IOC order is automatically canceled after the execution, the user may receive the order cancellation notification first, and then the transaction notification. <br>

If the user needs to get order updates updated sequentially, it is recommended to subscribe to another channel orders#${symbol}. <br>

### Subscribe to topics

`trade.clearing#${symbol}#${mode}`

### Subscription parameters
| parameter | data type | required | description |
| --------- | --------- | -------- | ----------- |
| symbol    | string    | TRUE     | Transaction code (supports wildcard *) |
| mode      | int       | FALSE    | Push mode (0 - push only when the order is completed; 1 - push both when the order is completed and canceled; default value: 0) |


Note: <br>
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
"action": "sub",
"code": 200,
"ch": "trade.clearing#btcusdt#0",
"data": {}
}
```

> Update example

```json
{
     "ch": "trade.clearing#btcusdt#0",
     "data": {
          "eventType": "trade",
          "symbol": "btcusdt",
          "orderId": 99998888,
          "tradePrice": "9999.99",
          "tradeVolume": "0.96",
          "orderSide": "buy",
          "aggressor": true,
          "tradeId": 919219323232,
          "tradeTime": 998787897878,
          "transactFee": "19.88",
          "feeDeduct": "0",
          "feeDeductType": "",
          "feeCurrency": "btc",
          "accountId": 9912791,
          "source": "spot-api",
          "orderPrice": "10000",
          "orderSize": "1",
          "clientOrderId": "a001",
          "orderCreateTime": 998787897878,
          "orderStatus": "partial-filled"
     }
}
```
### Data update field list (when the order is completed)
| Field | Data Type | Description |
| --------------- | -------- | ------------------------------------------------------------ |
| eventType | string | Event type (trade) |
| symbol | string | Transaction code |
| orderId | long | Order ID |
| tradePrice | string | Traded price |
| tradeVolume | string | Trade volume |
| orderSide | string | Order direction, valid values: buy, sell |
| orderType | string | Order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| aggressor | bool | Whether the trade was initiated by the active party, valid values: true, false |
| tradeId | long | Trade ID |
| tradeTime | long | Trade time (Unix time in milliseconds) |
| transactFee | string | Transaction fee (positive value) or transaction fee rebate (negative value) |
| feeCurrency | string | Transaction fee or transaction fee rebate currency (the transaction fee currency for buy orders is the base currency, the transaction fee currency for sell orders is the quote currency; the transaction fee rebate currency for buy orders is the denominated currency, and the transaction fee rebate currency for sell orders is the base currency) |
| feeDeduct | string | Transaction fee deduction |
| feeDeductType | string | Transaction fee deduction type, valid values: ht, point |
| accountId | long | Account ID |
| source | string | Order source |
| orderPrice | string | Order price (not applicable for market orders) |
| orderSize | string | Order quantity (not applicable for market buy orders) |
| orderValue | string | Order amount (only applicable for market buy orders) |
| clientOrderId | string | User-defined order number |
| stopPrice | string | Order trigger price (only available for stop-loss orders) |
| operator | string | Order trigger direction (only applicable for take profit and stop-loss orders) |
| orderCreateTime | long | Order creation time |
| orderStatus | string | Order status, valid values: filled, partial-filled |

Note: <br>

- The transaction rebate amount in transactFee may not arrive in real time;<br>

### Data update field list (when the order is canceled)
| Field | Data Type | Description |
| --------------- | -------- | ------------------------------------------------------------ |
| eventType | string | Event type (cancellation) |
| symbol | string | Transaction code |
| orderId | long | Order ID |
| orderSide | string | Order direction, valid values: buy, sell |
| orderType | string | Order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| accountId | long | Account ID |
| source | string | Order source |
| orderPrice | string | Order price (not applicable for market orders) |
| orderSize | string | Order quantity (not applicable for market buy orders) |
| orderValue | string | Order amount (only applicable for market buy orders) |
| clientOrderId | string | User-defined order number |
| stopPrice | string | Order trigger price (only available for stop-loss orders) |
| operator | string | Order trigger direction (only applicable for take profit and stop-loss orders) |
| orderCreateTime | long | Order creation time |
| remainAmt | string | Open volume (for market buy orders, this field is defined as unfilled volume) |
| orderStatus | string | Order status, valid values: canceled, partial-canceled |


## Subscribe account changes

API Key permission: read

Subscribe to order updates under your account.

### Subscribe to topics

`accounts. update#${mode}`

Users can choose any of the following ways to trigger account change push

1. Push only when the account balance changes;

2. Push both when the account balance changes or when the available balance changes, and push them separately.

### Subscription parameters

| Parameter | Data Type | Description |
| ---- | -------- | --------------------------------- |
| mode | integer | push mode, valid values: 0, 1, default value: 0 |

Subscription example
1. Do not fill in the mode:
accounts.update
Push only when account balance changes;
2. Fill in mode=0:
accounts.update#0
Push only when account balance changes;
3. Fill in mode=1:
accounts.update#1
When the account balance changes or the available balance changes, both push and push separately.

Note: No matter which subscription mode the user adopts, after the subscription is successful, the server will first push the current account balance and available balance of each account, and then push subsequent account updates. When the initial value of each account is first pushed, the values of changeType and changeTime in the message are null.

> Subscribe request

```json
{
"action": "sub",
"ch": "accounts. update"
}

```

> Response

```json
{
"action": "sub",
"code": 200,
"ch": "accounts. update#0",
"data": {}
}
```

> Update example

```json
accounts.update#0:
{
"action": "push",
"ch": "accounts. update#0",
"data": {
"currency": "btc",
"accountId": 123456,
"balance": "23.111",
"changeType": "transfer",
            "accountType": "trade",
"changeTime": 1568601800000
}
}

accounts.update#1:
{
"action": "push",
"ch": "accounts. update#1",
"data": {
"currency": "btc",
"accountId": 33385,
"available": "2028.699426619837209087",
"changeType": "order. match",
          "accountType": "trade",
"changeTime": 1574393385167
}
}
{
"action": "push",
"ch": "accounts. update#1",
"data": {
"currency": "btc",
"accountId": 33385,
"balance": "2065.100267619837209301",
"changeType": "order. match",
            "accountType": "trade",
"changeTime": 1574393385122
}
}
```
### Data update field list
| Field | Data Type | Description |
| ----------- | -------- | --------------------------------------------------------------- |
| currency | string | Currency |
| accountId | long | Account ID |
| balance | string | Account balance (only pushed when the account balance changes) |
| available | string | Available balance (only pushed when the available balance changes) |
| changeType | string | Balance change type, valid values: order-place (order creation), order-match (order transaction), order-refund (order transaction refund), order-cancel (order cancellation), order-fee-refund (deduct transaction fee) |
| accountType | string | Account type, valid values: trade, frozen, loan, interest |
| changeTime | long | Balance change time, UNIX time in milliseconds |


Note: <br>
The account update pushes the amount received, and multiple transaction rebates generated by multiple transactions may be combined into the account.

<br>
<br>
<br>
<br>
<br>
