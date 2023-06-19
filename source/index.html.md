---
title: BitV API Documentation

language_tabs: # must be one of https://git.io/vQNgJ
  - json

toc_footers:
  - <a href='https://www.bitv.com/api/'>Create API Key</a>

includes:

search: false

---

# Introduction

## API Introduction

Welcome to the BitV API!

This document serves as the official API documentation for BitV. The provided functionalities and services will be continuously updated here, so please stay tuned for updates.

You can use the menu above to switch between different business APIs and use the language button in the top right corner to switch the document language.

The right side of the document displays examples of request parameters and response results.

## Subscription Updates

Announcements regarding API additions, updates, deprecations, and other information will be provided in advance. We recommend that you follow and subscribe to our announcements to stay informed.

## Contact Us

If you have any questions or inquiries regarding API usage, please refer to the `Q&A` section for consultation.

# Quick Start

## Access Preparation

To use the API, please log in to the web portal first, complete the application for an API key, and configure the permissions according to the details in this document for development and trading.

You can click <a href='https://www.bitv.com/api/'>here




## Interface Types

We provide two types of interfaces for users. You can choose the appropriate method for querying market data, trading, or withdrawals based on your usage scenario and preferences.

### REST API

REST, which stands for Representational State Transfer, is a widely used communication mechanism based on HTTP. Each URL represents a resource.

For one-time operations such as trading or asset withdrawals, it is recommended for developers to use the REST API.

### WebSocket API

WebSocket is a new protocol introduced in HTML5. It enables full-duplex communication between the client and the server, allowing the server to actively push information to the client based on business rules.

For market data, order book depth, and other information, it is recommended for developers to use the WebSocket API.

**Authentication for API**

Both types of interfaces include public and private interfaces.

Public interfaces can be used to obtain basic information and market data. Public interfaces do not require authentication to be called.

Private interfaces can be used for trade management and account management. Each private request must be signed and authenticated using your API Key.

## Access URLs


**REST API**

**`https://api.bitv.com`**  

**WebSocket Feed (Market Data, excluding MBP incremental data)**

**`wss://api.bitv.com/ws`**  

**WebSocket Feed (Market Data, MBP incremental data only)**

**`wss://api.bitv.com/feed`**  

**WebSocket Feed (Assets and Orders)**

**`wss://api.bitv.com/ws/v2`**  


## Signature Authentication

### Signature Description

API requests are susceptible to tampering during transmission over the internet. To ensure that requests have not been modified, private interfaces (excluding basic information and market data) must be authenticated using your API Key to verify whether the parameters or parameter values have changed during transmission.

Each API Key requires appropriate permissions to access the corresponding interfaces. Permissions need to be assigned to each newly created API Key. Before using the interfaces, check the permissions required for each interface and confirm that your API Key has the necessary permissions.

A legitimate request consists of the following components:

- Method Request URL: The URL for accessing the server, such as https://api.bitv.com.
- API Access ID (AccessKeyId): The Access Key in your API Key.
- Signature Method (SignatureMethod): The hash-based protocol used to calculate the signature. In this case, HmacSHA256 is used.
- Signature Version (SignatureVersion): The version of the signature protocol. In this case, version 2 is used.
- Timestamp (Timestamp): The time (in UTC) when you send the request. For example: 2017-05-11T16:22:06. Including this value in the query request helps prevent third-party interception of your request.
- Required and Optional Parameters: Each method has a set of required parameters and optional parameters for defining the API call. You can refer to the documentation for each method to see these parameters and their meanings.
  - For GET requests, all the parameters included in each method need to be signed.
  - For POST requests, the parameters included in each method are not signed and should be placed in the request body.
- Signature: The calculated signature value used to ensure the validity and integrity of the signature.

### Signature Steps

To calculate the signature, the request needs to be normalized. Using a different content to calculate the HMAC results in completely different values. Therefore, before calculating the signature, normalize the request. The following example demonstrates the process using a request to query order details:

Complete URL for querying order details:

`https://api.bitv.com/v1/order/orders?`

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`&SignatureMethod=HmacSHA256`

`&SignatureVersion=2`

`&Timestamp=2017-05-11T15:19:30`

`&order-id=1234567890`

**1. Request method (GET or POST, GET for WebSocket), followed by a newline character "\n".**

For example:
`GET\n`

**2. Lowercase access domain, followed by a newline character "\n".**

For example:
`api.bitv.com\n`

**3. Path of the access method, followed by a newline character "\n".**

For example, for querying orders:
`
/v1/order/orders\n
`

For WebSocket v2:
`
/ws/v2
`

**4. URL-encode the parameters and sort them in ASCII order.**

For example, the original order of the request parameters (URL-encoded):

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`order-id=1234567890`

`SignatureMethod=HmacSHA256`

`SignatureVersion=2`

`Timestamp=2017-05-11T15%3A19%3A30`

<aside class="notice">
Use UTF-8 encoding and URL-encode the parameters. Hexadecimal characters must be in uppercase. For example, ":" is encoded as "%3A" and space is encoded as "%20".
</aside>
<aside class="notice">
The timestamp (Timestamp) should be added in the format of YYYY-MM-DDThh:mm:ss and URL-encoded.
</aside>

After sorting:

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`SignatureMethod=HmacSHA256`

`SignatureVersion=2`

`Timestamp=2017-05-11T15%3A19%3A30`

`order-id=1234567890`

**5. Concatenate the parameters using the character "&" according to the above order.**

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15%3A19%3A30&order-id=1234567890`

**6. Create the final string for signature calculation as follows:**

`GET\n`

`api.bitv.com\n`

`/v1/order/orders\n`

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15%3A19%3A30&order-id=1234567890`

**7. Generate a digital signature using the "Request String" obtained from the previous step and your secret key.**

1. Use the HmacSHA256 hash function with the request string and your API secret key as parameters to obtain the hash value.
2. Base64-encode the hash value to obtain the digital signature for this API call.

`4F65x5A2bLyMWVQj3Aqp+B4w+ivaA7n5Oi2SuYtCJ9o=`

**8. Add the generated digital signature to the request.**

For REST interfaces:

1. Add all the required authentication parameters to the path parameters of the API call.
2. URL-encode the digital signature and add it as a path parameter. The parameter name is "Signature".

Finally, the API request sent to the server should be:

`https://api.bitv.com/v1/order/orders?AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&order-id=1234567890&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15%3A19%3A30&Signature=4F65x5A2bLyMWVQj3Aqp%2BB4w%2BivaA7n5Oi2SuYtCJ9o%3D`

For WebSocket interfaces:

1. Fill in the parameters and signature in the required JSON format.
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

Sub-users can be used to separate assets and trading. Assets can be transferred between main and sub-users. Sub-users can only trade within their own accounts, and assets cannot be transferred directly between sub-users. Only the main user has the authority to transfer assets.

Sub-users have independent login credentials and API Keys, which are managed by the main user on the web portal.

Each main user can create up to 200 sub-users, and each sub-user can create up to 5 sets of API Keys. Each API Key can be set with Read and Trade permissions.

API Keys for sub-users can also be bound to IP addresses, and the validity period is the same as that of the main user's API Keys.

Sub-users can access all public interfaces, including basic information and market data. The private interfaces that sub-users can access are as follows:

| Interface                                                    | Description                    |
| ------------------------------------------------------------ | ------------------------------- |
| [POST /v1/order/orders/place](#fd6ce2a756)                   | Create and execute an order     |
| [POST /v1/order/orders/{order-id}/submitcancel](#4e53c0fccd) | Cancel an order                 |
| [POST /v1/order/orders/submitCancelClientOrder](#client-order-id) | Cancel an order based on the client order ID |
| [POST /v1/order/orders/batchcancel](#ad00632ed5)             | Cancel multiple orders          |
| [POST /v1/order/orders/batchCancelOpenOrders](#open-orders)  | Cancel all current orders       |
| [GET /v1/order/orders/{order-id}](#92d59b6aad)               | Query order details             |
| [GET /v1/order/orders](#d72a5b49e7)                          | Query current and historical orders |
| [GET /v1/order/openOrders](#95f2078356)                      | Query current open orders       |
| [GET /v1/order/matchresults](#0fa6055598)                    | Query trade details             |
| [GET /v1/order/orders/{order-id}/matchresults](#56c6c47284)  | Query match results of a specific order |
| [GET /v1/account/accounts](#bd9157656f)                      | Query all user accounts         |
| [GET /v1/account/accounts/{account-id}/balance](#870c0ab88b) | Query balance of a specific account |
| [GET /v1/account/history](#84f1b5486d)                       | Query account transaction history |
| [GET /v2/account/ledger](#2f6797c498)                        | Query financial transaction history |
| [POST /v1/account/transfer](#0d3c2e7382)                     | Asset transfer                  |

<aside class="notice">
Sub-users cannot access other interfaces. If attempted, the system will return "error-code 403".
</aside>



## Business Glossary

### Trading Pairs

A trading pair consists of a base currency and a quote currency. For example, in the trading pair BTC/USDT, BTC is the base currency, and USDT is the quote currency.

The base currency corresponds to the field "base-currency".

The quote currency corresponds to the field "quote-currency".

### Accounts

Different businesses require different accounts. The account ID (`account-id`) serves as the unique identifier for different business accounts.

The account ID can be obtained through the `/v1/account/accounts` interface, and specific accounts can be distinguished based on the account type (`account-type`).

Account types include:

- spot: Spot accounts

### Order and Trade ID Explanation

- `order-id`: Unique identifier for an order
- `client-order-id`: Custom ID provided by the client during order placement. It corresponds to the `order-id` returned after a successful order placement and is valid for 24 hours. Allowed characters include letters (case sensitive), numbers, underscores (_), and hyphens (-), with a maximum length of 64 characters.
- `match-id`: Sequential number assigned to an order during matching
- `trade-id`: Unique identifier for a trade

### Order Types

The current order types are composed of the buy/sell direction and the order operation type. For example, "buy-market" indicates the buy direction and the market order operation.

Buy/Sell directions:

- buy: Buy
- sell: Sell

Order types:

- limit: Limit order. This type of order requires specifying the order price and quantity.
- market: Market order. This type of order only requires specifying the order amount or quantity, without specifying the price. The order is matched directly with the counterparty until the amount or quantity falls below the minimum transaction amount or quantity.
- limit-maker: Limit maker order. This order can only enter the market depth as a maker during matching. If the order would be executed, the matching will directly reject the order.
- ioc: Immediate or Cancel. This order, when entered into matching, will be canceled directly if it cannot be executed immediately (even partially filled). 
- stop-limit: Stop-limit order. It sets an order above or below the market price. The order is formally entered into the matching queue only when it reaches the trigger price.

### Order Status

- submitted: Waiting for execution. Orders in this status have entered the matching queue.
- partial-filled: Partially filled. Orders in this status are in the matching queue, and a portion of the order quantity has been traded, waiting for the remaining portion to be filled.
- filled: Filled. Orders in this status are not in the matching queue anymore, and the entire order quantity has been traded.
- partial-canceled: Partially filled and canceled. Orders in this status are not in the matching queue anymore. They transition from the partial-filled status, indicating that a portion of the order quantity was traded but then canceled.
- canceled: Canceled. Orders in this status are not in the matching queue anymore. They were successfully canceled without any traded quantity.
- canceling: Canceling. Orders in this status are currently in the process of being canceled. The order needs to be removed from the matching queue to be truly canceled, so this status serves as an intermediate state.

# Integration Guide

## API Overview

| API Category | Category Link                  | Description                                          |
| ------------ | ------------------------------ | ---------------------------------------------------- |
| Basic        | /v1/common/*                   | Basic API category, including currency, currency pair, timestamp, etc. |
| Market       | /market/*                      | Public market-related API, including trade, depth, ticker, etc. |
| Account      | /v1/account/*  /v1/subuser/*    | Account-related API, including account information, subusers, etc. |
| Order        | /v1/order/*                    | Order-related API, including order placement, cancellation, order query, trade query, etc. |

This categorization is a general classification. Some APIs may not follow this rule. Please refer to the relevant API documentation based on your needs.

## New Rate Limit Rules

- Currently, the new rate limit rules are being gradually rolled out. The new rate limit rules apply to APIs that have been individually marked with rate limit values and labeled as NEW.

- The new rate limit rules adopt a UID-based rate limiting mechanism, which means that the frequency of requests from different API Keys under the same UID to a specific node should not exceed the maximum allowed access limit for that node within a unit time.

- Users can check the current rate limit usage and the expiration time of the current time window by using the "X-HB-RateLimit-Requests-Remain" (remaining rate limit count) and "X-HB-RateLimit-Requests-Expire" (window expiration time) in the HTTP header. Based on this information, you can dynamically adjust your request frequency.

## Rate Limit Rules

For APIs without the NEW rate limit values individually marked:

- Each API Key is limited to 10 requests per second.
- If an API does not require an API Key, each IP is limited to 10 requests per second.

For example:

- Asset order-related APIs are rate-limited based on the API Key: 10 requests per second.
- Market-related APIs are rate-limited based on IP: 10 requests per second.

## Request Format

All API requests are RESTful, and currently, there are only two methods: GET and POST.

- GET requests: All parameters are included in the path parameters.
- POST requests: All parameters are sent in JSON format in the request body.

## Response Format

All interfaces return data in JSON format. There are slight differences in the JSON structure between v1 and v2 interfaces.

**v1 Interface Response Format**: The top-level contains four fields: `status`, `ch`, `ts`, and `data`. The first three fields represent the request status and attributes, and the actual business data is in the `data` field.

Here is an example of the response format:

```json
{
  "status": "ok",
  "ch": "market.btcusdt.kline.1day",
  "ts": 1499223904680,
  "data": // per API response data in nested JSON object
}


| Parameter Name | Data Type | Description          |
| -------------- | --------- | -------------------- |
| code           | int       | API interface code   |
| message        | string    | Error message (if any) |
| data           | object    | Interface response data body |

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

| name | type | required | description |
| ----------------- | ------- | -------- | -------------- ---------------------------------------------- |
| code | integer | TRUE | status code |
| message | string | FALSE | error description (if any) |
| data | object | TRUE | |
| { marketStatus | integer | TRUE | market status (1=normal, 2=halted, 3=cancel-only) |
| haltStartTime | long | FALSE | market pause start time (unix time in millisecond), only valid for marketStatus=halted or cancel-only |
| haltEndTime | long | FALSE | The expected end time of market suspension (unix time in millisecond), only valid for marketStatus=halted or cancel-only; if this field is not returned when marketStatus=halted or cancel-only, it means that the market suspension is over The time is temporarily unpredictable |
| haltReason | integer | FALSE | Reason for market suspension (2=emergency-maintenance, 3=scheduled-maintenance), only valid for marketStatus=halted or cancel-only |
| affectedSymbols } | string | FALSE | A list of trading pairs affected by market suspension, separated by commas, if all trading pairs are affected, return "all", only valid for marketStatus=halted or cancel-only |

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

| field name | required | data type | description |
| -------------------------- | -------- | -------- | ---- -------------------------------------------------- ------ |
| base-currency | true | string | base currency in the transaction pair |
| quote-currency | true | string | quote currency in the trading pair |
| price-precision | true | integer | The precision of the trading pair quotation (digits after the decimal point) |
| amount-precision | true | integer | trading pair base currency counting precision (digits after the decimal point) |
| symbol-partition | true | string | transaction partition, possible values: [main, innovation] |
| symbol | true | string | trading pair |
| state | true | string | trading pair status; possible values: [online, offline,suspend] online - online; offline - trading pair is offline and cannot be traded; suspend - trading is suspended; pre-online - coming soon |
| value-precision | true | integer | The precision of the transaction amount of the transaction pair (digits after the decimal point) |
| min-order-amt | true | float | The minimum order size of a limit order for a trading pair, in the base currency (to be obsolete) |
| max-order-amt | true | float | The maximum order size of a limit order for a trading pair, in the base currency (to be obsolete soon) |
| limit-order-min-order-amt | true | float | The minimum order size of a limit order for a trading pair, in base currency (NEW) |
| limit-order-max-order-amt | true | float | The maximum order size of a limit order for a trading pair, in base currency (NEW) |
| sell-market-min-order-amt | true | float | The minimum order size of a market sell order for a trading pair, in base currency (NEW) |
| sell-market-max-order-amt | true | float | The maximum order size of a market sell order for a trading pair, in base currency (NEW) |
| buy-market-max-order-value | true | float | The maximum order value of a buy order at the market price of the trading pair, in the unit of pricing currency (NEW) |
| min-order-value | true | float | The minimum order amount for a limit order and a market buy order for a trading pair, in the pricing currency |
| max-order-value | false | float | The maximum order amount of a limit order and a market buy order for a trading pair, in converted USDT (NEW) |
| api-trading | true | string | API trading enable flag (valid value: enabled, disabled) |

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

| field name | required | type | field description | value range |
| -------------- | -------- | ------- | ---------- | -------------------------------------------------- ---- |
| currency | false | string | currency | btc, ltc, bch, eth, etc ... (refer to `GET /v1/common/currencys`) |
| authorizedUser | false | boolean | authenticated user | true or false (if not filled, the default is true) |

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


| field name | required | data type | field description | value range |
| ----------------------- | -------- | -------- | ------- -------------------------------------------------- --- | ---------------------- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| { currency | true | string | currency | |
| { chains | true | object | | |
| chain | true | string | chain name | |
| displayName | true | string | chain display name | |
| baseChain | false | string | underlying chain name | |
| baseChainProtocol | false | string | underlying chain protocol | |
| isDynamic | false | boolean | Whether dynamic fee (only valid for fixed type, withdrawFeeType=fixed) | true, false |
| numOfConfirmations | true | int | The number of confirmations required for secure account login (coin withdrawals are allowed after reaching the number of confirmations) | |
| numOfFastConfirmations | true | int | The number of confirmations required for fast account transfer (transactions are allowed but withdrawals are not allowed after reaching the number of confirmations) | |
| minDepositAmt | true | string | minimum deposit amount | |
| depositStatus | true | string | deposit status | allowed,prohibited |
| minWithdrawAmt | true | string | minimum withdrawal amount | |
| maxWithdrawAmt | true | string | single maximum withdrawal amount | |
| withdrawQuotaPerDay | true | string | Daily withdrawal quota (Singapore time zone) | |
| withdrawQuotaPerYear | true | string | withdrawal quota for the year | |
| withdrawQuotaTotal | true | string | total withdrawal quota | |
| withdrawPrecision | true | int | withdrawal precision | |
| withdrawFeeType | true | string | Withdrawal fee type (the type of withdrawal fee for a specific currency on a specific chain is unique) | fixed,circulated,ratio |
| transactFeeWithdraw | false | string | single withdrawal fee (only valid for fixed type, withdrawFeeType=fixed) | |
| minTransactFeeWithdraw | false | string | Minimum single withdrawal fee (only valid for interval type and ratio type with lower limit, withdrawFeeType=circulated or ratio) | |
| maxTransactFeeWithdraw | false | string | Maximum single withdrawal fee (only valid for interval type and ratio type with upper limit, withdrawFeeType=circulated or ratio) | |
| transactFeeRateWithdraw | false | string | transaction fee rate for a single withdrawal (only valid for ratio type, withdrawFeeType=ratio) | |
| withdrawStatus} | true | string | withdrawal status | allowed,prohibited |
| instStatus } | true | string | currency status | normal,delisted |

### status code

| Status Code | Error Message | Error Scenario Description |
| ------ | -------------------------------------- | ------ ------ |
| 200 | success | Request succeeded |
| 500 | error | System error |
| 2002 | invalid field value in "field name" | illegal field value |

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

| Error Code | Error Message | Description |
| ----------------- | -------------------------------- ---- | ----------------------- |
| invalid-parameter | invalid symbol | invalid trading pair |
| invalid-parameter | invalid period | request K line, period parameter is wrong |
| invalid-parameter | invalid depth | Incorrect depth parameter |
| invalid-parameter | invalid type | Depth type parameter error |
| invalid-parameter | invalid size | wrong size parameter |
| invalid-parameter | invalid size,valid range: [1, 2000] | wrong size parameter |
| invalid-parameter | request timeout | request timeout |


## K-line data (candle chart)

This interface returns historical K-line data.

```shell
curl "https://api.bitv.com/market/history/kline?period=1day&size=200&symbol=btcusdt"
```

### HTTP requests

- GET `/market/history/kline`

### Request parameters

| parameter | data type | required | default value | description | value range |
| ------ | -------- | -------- | ------ | ----------------- ------------------------- | ------------------------ --------------------------------------- |
| symbol | string | true | NA | trading pair | btcusdt, ethbtc, etc. |
| period | string | true | NA | Return data time granularity, that is, the time interval of each candle | 1min, 5min, 15min, 30min, 60min, 4hour, 1day, 1mon, 1week, 1year |
| size | integer | false | 150 | Return the number of K-line data | [1, 2000] |

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
| -------- | -------- | ------------------------------- ------------------------ |
| id | long | The time stamp adjusted to Singapore time, in seconds, and used as the id of this K-line column |
| amount | float | transaction amount in base currency |
| count | integer | transaction count |
| open | float | the opening price of this stage |
| close | float | the closing price of this stage |
| low | float | the lowest price in this stage |
| high | float | the highest price at this stage |
| vol | float | volume in quote currency |

## Aggregation Quotes (Ticker)

This interface obtains ticker information and provides transaction aggregation information in the last 24 hours.

```shell
curl "https://api.bitv.com/market/detail/merged?symbol=ethusdt"
```

### HTTP requests

- GET `/market/detail/merged`

### Request parameters

| parameter | data type | required | default value | description | value range |
| ------ | -------- | -------- | ------ | ------ | ---------- ----------------------------------------------- |
| symbol | string | true | NA | Trading pair | btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for value) |

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
| -------- | -------- | ------------------------------- --------- |
| id | long | NA |
| amount | float | transaction volume in base currency (rolling 24 hours) |
| count | integer | number of transactions (according to rolling 24 hours) |
| open | float | Opening price of this stage (according to rolling 24 hours) |
| close | float | The latest price at this stage (according to rolling 24 hours) |
| low | float | The lowest price of this stage (according to rolling 24 hours) |
| high | float | The highest price of this stage (according to rolling 24 hours) |
| vol | float | volume in quote currency (rolling 24 hours) |
| bid | object | current highest bid price [price, size] |
| ask | object | current minimum ask price [price, size] |

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
| -------- | -------- | ------------------------------- --------- |
| amount | float | transaction volume in base currency (rolling 24 hours) |
| count | integer | Number of transactions (according to rolling 24 hours) |
| open | float | Opening price (calculated in natural days in Singapore time) |
| close | float | Latest Price (Singapore Time Natural Day) |
| low | float | Lowest price (in Singapore time calendar days) |
| high | float | Highest price (in Singapore time natural day) |
| vol | float | volume in quote currency (rolling 24 hours) |
| symbol | string | trading pair, such as btcusdt, ethbtc |
| bid | float | buy price |
| bidSize | float | buy a quantity |
| ask | float | Ask price |
| askSize | float | sell a quantity |

## Depth of Market Data

This interface returns the current market depth data for the specified trading pair.

```shell
curl "https://api.bitv.com/market/depth?symbol=btcusdt&type=step2"
```

### HTTP requests

- GET `/market/depth`

### Request parameters

| parameter | data type | required | default value | description | value range |
| ------ | -------- | ----- | ------ | ----------------- ------------ | ------------------------------------- ----------------- |
| symbol | string | true | NA | Trading pair | btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for value) |
| depth | integer | false | 20 | number of depths to return | 5, 10, 20 |
| type | string | true | step0 | In-depth price aggregation, see below for details | step0, step1, step2, step3, step4, step5 |

<aside class="notice">When the type value is 'step0', the default value of 'depth' is 150 instead of 20. </aside>

**Description of each value of parameter type**

| Value | Description |
| ----- | --------------------- |
| step0 | no aggregation |
| step1 | Aggregation degree is quote precision*10 |
| step2 | Aggregation degree is quote precision*100 |
| step3 | Aggregation degree is quote precision * 500 |
| step4 | Aggregation degree is quote precision * 1000 |

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
| -------- | -------- | ------------------------------- --- |
| ts | integer | Timestamp adjusted to Singapore time, in milliseconds |
| version | integer | internal field |
| bids | object | all current bids [price, size] |
| asks | object | all current ask orders [price, size] |

## Recent market transaction records

This interface returns the latest transaction record of the specified trading pair.

```shell
curl "https://api.bitv.com/market/trade?symbol=ethusdt"
```

### HTTP requests

- GET `/market/trade`

### Request parameters

| parameter | data type | required | default value | description |
| ------ | -------- | -------- | ------ | ----------------- ----------------------------------------- |
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
| --------- | -------- | --------------------------- -------------------- |
| id | integer | unique transaction id (will be discarded) |
| trade-id | integer | unique transaction ID (NEW) |
| amount | float | transaction amount in base currency |
| price | float | transaction price in quote currency |
| ts | integer | Timestamp adjusted to Singapore time, in milliseconds |
| direction | string | Transaction direction: "buy" or "sell", "buy" means to buy, "sell" means to sell |

## Get recent transaction records

This interface returns all recent transaction records of the specified trading pair.

```shell
curl "https://api.bitv.com/market/history/trade?symbol=ethusdt&size=2"
```

### HTTP requests

- GET `/market/history/trade`

### Request parameters

| parameter | data type | required | default value | description |
| ------ | -------- | -------- | ------ | ----------------- ----------------------------------------- |
| symbol | string | true | NA | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |
| size | integer | false | 1 | the number of transaction records to return, the maximum value is 2000 |

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
| --------- | -------- | --------------------------- -------------------- |
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

| parameter | data type | required | default value | description |
| ------ | -------- | -------- | ------ | ----------------- ----------------------------------------- |
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
| -------- | -------- | ------------------------------- --------- |
| id | integer | response id |
| amount | float | transaction volume in base currency (rolling 24 hours) |
| count | integer | number of transactions (according to rolling 24 hours) |
| open | float | Opening price of this stage (according to rolling 24 hours) |
| close | float | The closing price of this stage (according to rolling 24 hours) |
| low | float | The lowest price of this stage (according to rolling 24 hours) |
| high | float | The highest price of this stage (according to rolling 24 hours) |
| vol | float | volume in quote currency (rolling 24 hours) |
| version | integer | internal data |

# Account related

## Introduction

The account-related interface provides functions such as account, balance, history query and asset transfer.

<aside class="notice">Access to account-related interfaces requires signature authentication. </aside>

The following are the error codes, error messages and descriptions returned by account-related interfaces.

| Error Code | Error Message | Description |
| ------ | ------------------------------------------ - | ------------------------------------------------ --- |
| 500 | system error | Exception in calling internal service |
| 1002 | forbidden | Forbidden operation, such as the accountId and UID in the user input parameters are inconsistent |
| 2002 | "invalid field value in `currency`" | currency does not conform to regular rules ^[a-z0-9]{2,10}$ |
| 2002 | "invalid field value in `transactTypes`" | The change type transactTypes is not "transfer" |
| 2002 | "invalid field value in `sort`" | pagination request parameter is not valid "asc or desc" |
| 2002 | "value in `fromId` is not found in record” | fromId not found |
| 2002 | "invalid field value in `accountId`" | accountId in the query parameter is empty |
| 2002 | "value in `startTime` exceeded valid range" | The parameter query time is greater than the current time, or more than 180 days from the current time |
| 2002 | "value in `endTime` exceeded valid range") | The query end time is less than the start time, or the query time span is greater than 10 days |

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
| -------- | -------- | -------- | ---------- | ----------- -------------------- |
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
| ---------- | -------- | ------ | ------------------- ----------------------------------------- | ------ | ---- ---- |
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
| -------- | -------- | -------- | -------- | ------------- ------------------ |
| id | true | long | account ID | |
| state | true | string | account status | working: normal lock: account is locked |
| type | true | string | account type | spot: spot account |
| list | false | Array | | |

list field description

| Parameter name | Required | Data type | Description | Value range |
| -------- | -------- | -------- | ---- | ----------------- ---------------- |
| balance | true | string | balance | |
| currency | true | string | currency | |
| type | true | string | type | trade: trade balance, frozen: frozen balance |

## Get account asset valuation

API Key permission: read

Frequency limit value (NEW): 100 times/2s

According to BTC or fiat currency denomination unit, obtain the total asset valuation of the specified account.

### HTTP requests

- GET `/v2/account/asset-valuation`

### Request parameters

| Parameter | Required | Data Type | Description | Default Value | Value Range |
| ----------------- | -------- | -------- | ------------- ----------------------------------------------- | ----- - | ------------------------------------- |
| accountType | true | string | account type | NA | spot: spot account |
| valuationCurrency | false | string | Asset valuation fiat currency, that is, which fiat currency is used to value assets. | BTC | Available legal currencies are: BTC, USD (case sensitive) |
| subUid | false | long | The UID of the sub-user, if not filled, returns the account asset valuation of the user whose API key belongs | NA | |

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

|Parameter|Required | Data Type | Description |
|-----------|------------|-----------|------------ |----------|
| balance | true | string | total asset valuation based on a certain fiat currency |
| timestamp | true | long | data return time, which is unix time in millisecond |


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

| Parameter | Required | Data Type | Description | Value Range |
| ----------------- | -------- | -------- | ------------- ---------------------- | --------------------------- ----- |
| from-user | true | long | transfer-out user uid | parent user uid, child user uid |
| from-account-type | true | string | transfer-out account type | spot |
| from-account | true | long | transfer account id | |
| to-user | true | long | transfer-in user uid | parent user uid, child user uid |
| to-account-type | true | string | Transfer to account type | spot |
| to-account | true | long | Transfer to account id | |
| currency | true | string | Currency, namely btc, ltc, bch, eth, etc ... | Value reference GET /v1/common/currencys |
| amount | true | string | transfer amount | |


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

| parameter | required | data type | description | value range |
| --------------- | -------- | -------- | ---------- | ---- ----------- |
| status | true | string | status | "ok" or "error" |
| data | true | list | | |
| { transact-id | true | int | transaction serial number | |
| transact-time } | true | long | transaction time | |


## Account History

API Key Permission: Read<br>
Frequency limit value (NEW): 5 times/2s

This node returns the account history based on the user account ID.

###HTTP Request

- GET `/v1/account/history`

### Request parameters

| Parameter name | Required | Data type | Description | Default value | Value range |
| -------------- | -------- | -------- | ---------------- ----------------------------------------------- | ----- --------------- | ---------------------------------- ----------------------------- |
| account-id | true | string | account number, refer to `GET /v1/account/accounts` | | |
| currency | false | string | Currency, ie btc, ltc, bch, eth, etc... (refer to `GET /v1/common/currencys` for value) | | |
| transact-types | false | string | change types, multiple choices, separated by commas | all | trade (transaction), transact-fee (transaction fee), fee-deduction (deduction of transaction fee), transfer (transfer ), deposit (deposit), withdraw (withdrawal), withdraw-fee (withdrawal fee), other-types (other), rebate (transaction rebate) |
| start-time | false | long | Unix time in millisecond. Use transact-time as the key to search. The maximum query window is 1 hour. The window translation range is the last 30 days. | ((end-time) – 1hour ) | [((end-time) – 1hour), (end-time)] |
| end-time | false | long | Unix time in millisecond. Use transact-time as the key to search. The maximum query window is 1 hour. The window translation range is the last 30 days. | current-time | [(current- time) – 29days,(current-time)] |
| sort | false | string | search direction | asc | asc or desc |
| size | false | int | maximum number of entries | 100 | [1,500] |
| from-id | false | long | start number (only valid when querying on the next page) | | |

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

| Field name | Data type | Description | Value range |
| ------------- | -------- | -------------------------- -------------------------- | -------- |
| status | string | status code | |
| data | object | | |
| { account-id | long | account number | |
| currency | string | currency | |
| transact-amt | string | Change amount (Positive for deposit or Negative for deposit) | |
| transact-type | string | transact type | |
| avail-balance | string | available balance | |
| acct-balance | string | account balance | |
| transact-time | long | transaction time (database record time) | |
| record-id } | long | database record ID (globally unique) | |
| next-id | long | The start number of the next page (this field is only included when the query results need to be returned in pages) | |

## Financial statement

API Key permission: read

This node returns the financial history based on the user account ID. <br>
For the first phase of the launch, only the query of transfer transaction (“transactType” = “transfer”) is currently supported. <br>
The query window framed by "startTime"/"endTime" is up to 10 days, which means that the range that can be retrieved through a single query is up to 10 days. <br>
The query window can be shifted within the range of the last 180 days, that is, records of the past 180 days can be retrieved at most through multiple shift window queries. <br>

###HTTP Request

- GET `/v2/account/ledger`

### Request parameters

| parameter name | data type | required | description |
| ------------- | -------- | -------- | ----------------- ------------------------------------- |
| accountId | string | TRUE | account ID |
| currency | string | FALSE | currency (default all currencies) |
| transactTypes | string | FALSE | Transact type, can fill in more (default value is all) Enumeration value: transfer |
| startTime | long | FALSE | Apogee time (see note 1 for value range and default value) |
| endTime | long | FALSE | Peripheral time (see Note 2 for value range and default value) |
| sort | string | FALSE | search direction (asc from far to near, desc from near to far, default value desc) |
| limit | int | FALSE | maximum number of items returned in a single page [1,500] (default 100) |
| fromId | long | FALSE | Starting number (only valid when querying on the next page, see note 3) |

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

| Field name | Data type | Required | Description | Value range |
| ------------ | -------- | -------- | ------------------ -------------------------------------------- | ------- -------------------------------------------------- --- |
| code | integer | TRUE | status code | |
| message | string | FALSE | error description (if any) | |
| data | object | TRUE | in the order defined in the user request parameter sort | |
| { accountId | integer | TRUE | account ID | |
| currency | string | TRUE | currency | |
| transactAmt | number | TRUE | Amount of change (Positive for incoming or negative for outgoing) | |
| transactType | string | TRUE | transact type | transfer |
| transferType | string | FALSE | transfer type (only valid for transactType=transfer) | master-transfer-in (transfer to parent user), master-transfer-out (transfer from parent user), sub-transfer-in (transfer to sub-user), sub-transfer-out (transfer from sub-user) |
| transactId | integer | TRUE | transaction serial number | |
| transactTime | integer | TRUE | transaction time |

# Wallet (deposit and withdrawal related)

## Introduction

The interface related to deposit and withdrawal provides functions such as deposit address, withdrawal address, withdrawal amount, deposit and withdrawal records, etc., as well as functions such as withdrawal and cancellation of withdrawal.

<aside class="notice">Signature authentication is required to access the interfaces related to deposit and withdrawal. </aside>

The following are the return codes, return messages and instructions returned by the relevant interfaces of deposit and withdrawal.

| Return Code | Return Message | Description |
| ------ | ------------------------------------ | ----- ------- |
| 200 | success | Request succeeded |
| 500 | error | System error |
| 1002 | unauthorized | Unauthorized |
| 1003 | invalid signature | Signature verification failed |
| 2002 | invalid field value in "field name" | illegal field value |
| 2003 | missing mandatory field "field name" | mandatory field missing |

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

| field name | required | type | field description | value range |
| -------- | -------- | ------ | -------- | --------------- ------------------------------------------------ |
| currency | true | string | Currency | btc, ltc, bch, eth, etc ... (value reference `GET /v1/common/currencys`) |

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


| field name | required | data type | field description | value range |
| ---------- | -------- | -------- | ---------------- | --- ----- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| {currency | true | string | currency | |
| address | true | string | deposit address | |
| addressTag | true | string | deposit address tag | |
| chain } | true | string | chain name | |

### status code

| Status Code | Error Message | Error Scenario Description |
| ------ | ------------------------------------ | ----- ------- |
| 200 | success | Request succeeded |
| 500 | error | System error |
| 1002 | unauthorized | Unauthorized |
| 1003 | invalid signature | Signature verification failed |
| 2002 | invalid field value in "field name" | illegal field value |
| 2003 | missing mandatory field "field name" | mandatory field missing |

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

| field name | required | type | field description | value range |
| -------- | -------- | ------ | -------- | --------------- ------------------------------------------------ |
| currency | true | string | Currency | btc, ltc, bch, eth, etc ... (value reference `GET /v1/common/currencys`) |

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

| field name | required | data type | field description | value range |
| -------------------------- | -------- | -------- | ---- ------------ | -------- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| currency | true | string | currency | |
| chains | true | object | | |
| { chain | true | string | chain name | |
| maxWithdrawAmt | true | string | single maximum withdrawal amount | |
| withdrawQuotaPerDay | true | string | daily withdrawal quota | |
| remainWithdrawQuotaPerDay | true | string | remaining withdrawal quota for the day | |
| withdrawQuotaPerYear | true | string | withdrawal quota for the year | |
| remainWithdrawQuotaPerYear | true | string | remaining withdrawal quota for the year | |
| withdrawQuotaTotal | true | string | total withdrawal quota | |
| remainWithdrawQuotaTotal } | true | string | remaining withdrawal quota | |

### status code

| Status Code | Error Message | Error Scenario Description |
| ------ | -------------------------------------- | ------ ------ |
| 200 | success | Request succeeded |
| 500 | error | System error |
| 1002 | unauthorized | Unauthorized |
| 1003 | invalid signature | Signature verification failed |
| 2002 | invalid field value in "field name" | illegal field value |

## Withdraw address query

API Key Permission: Read<br>

This node is used to query the withdrawal addresses available for the API key, and is only available to parent users. <br>

### HTTP requests

- GET `/v2/account/withdraw/address`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| -------- | -------- | ------ | ------------------------ ------------------------------ | ------------------- ----------- | -------------------------------------- ---------------------- |
| currency | true | string | Currency | | btc, ltc, bch, eth, etc ... (Refer to `GET /v1/common/currencys`) |
| chain | false | string | chain name | If not filled, return the withdrawal addresses of all chains | |
| note | false | string | address note | If not filled, return all note withdrawal addresses | |
| limit | false | int | maximum number of items returned in a single page | 100 | [1,500] |
| fromId | false | long | Starting number (withdrawal address ID, only valid when querying on the next page, see notes for details) | NA | |

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

| Parameter name | Required | Data type | Description | Value range |
| ---------- | -------- | -------- | -------------------- ------------------------------------------- | -------- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| { currency | true | string | currency | |
| chain | true | string | chain name | |
| note | true | string | address note | |
| addressTag | false | string | address tag, if any | |
| address } | true | string | address | |
| nextId | false | long | The starting number of the next page (withdrawal address ID, this field is only included when the query results need to be returned in pages, see the remarks for details) | |

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

| parameter name | required | type | description | value range |
| -------- | -------- | ------ | ------------------------ -------------------------------------- | ------------- ----------------------------------------------- |
| address | true | string | Withdrawal address | Only supports addresses in the corresponding currency address list on the official website |
| amount | true | string | withdrawal amount | |
| currency | true | string | asset type | btc, ltc, bch, eth, etc ... (refer to `GET /v1/common/currencys`) |
| fee | true | string | transfer fee | |
| chain | false | string | Value reference `GET /v2/reference/currencies`, for example, when withdrawing USDT to OMNI, this parameter must be set to "usdt", when withdrawing USDT to TRX, this parameter must be set to "trc20usdt", others Currency withdrawal does not need to set this parameter | |
| addr-tag | false | string | virtual currency shared address tag, suitable for xrp, xem, bts, steem, eos, xmr | format, integer string like "123" |

> Response:

```json
{
   "data": 700
}
```

### Response data


| Parameter name | Required | Data type | Description | Value range |
| -------- | -------- | -------- | ------- | -------- |
| data | false | long | withdrawal ID | |

## Cancel withdrawal

This node is used to cancel the submitted withdrawal request and is only available to parent users

API Key Permission: Withdrawal<br>
Frequency limit value (NEW): 20 times/2s

### HTTP requests

- POST ` /v1/dw/withdraw-virtual/{withdraw-id}/cancel`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| ----------- | -------- | ---- | --------------------- | - ----- | -------- |
| withdraw-id | true | long | withdrawal ID, fill in path | | |


> Response:

```json
{
   "data": 700
}
```

### Response data


| Parameter name | Required | Data type | Description | Value range |
| -------- | -------- | -------- | ------- | -------- |
| data | false | long | withdrawal ID | |

## Deposit and withdrawal record

This node is used to query deposit and withdrawal records, both parent and child users are available

API Key Permission: Read<br>
Frequency limit value (NEW): 20 times/2s

### HTTP requests

- GET `/v1/query/deposit-withdraw`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| -------- | -------- | ------ | ---------------- | ------- -------------------------------------------------- --- | ---------------------------------------------- -------------- |
| currency | false | string | Currency | | btc, ltc, bch, eth, etc ... (Refer to `GET /v1/common/currencys`) |
| type | true | string | recharge or withdrawal | | deposit or withdraw, sub-users can only deposit |
| from | false | string | query starting ID | By default, the default value is direct. When direct is 'prev', from is 1, return from old to new in ascending order; when direct is 'next', from is the ID of the latest record, and return from new to old in descending order | |
| size | false | string | query record size | 100 | 1-500 |
| direct | false | string | return record sorting direction | default, the default is "prev" (ascending) | "prev" (ascending) or "next" (descending) |

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
| ----------- | -------- | -------- | ------------------- -------------------------------------------- | -------- ----------------------------------- |
| id | true | long | deposit order id | |
| type | true | string | type | 'deposit', 'withdraw', only deposit for sub-users |
| currency | true | string | currency | |
| tx-hash | true | string | transaction hash | |
| chain | true | string | chain name | |
| amount | true | float | number | |
| address | true | string | destination address | |
| address-tag | true | string | address-tag | |
| fee | true | float | handling fee | |
| state | true | string | state | state see table below |
| error-code | false | string | Withdrawal failure error code, only when the type is "withdraw" and the state is "reject", "wallet-reject" and "failed". | |
| error-msg | false | string | Withdrawal failure error description, only when the type is "withdraw" and the state is "reject", "wallet-reject" and "failed". | |
| created-at | true | long | creation time | |
| updated-at | true | long | last updated time | |

- Definition of virtual currency recharge status:

| Status | Description |
| ---------- | -------- |
| unknown | status unknown |
| confirming | confirming |
| confirmed | confirmed |
| safe | Completed |
| orphan | To be confirmed |

- Definition of virtual currency withdrawal status:

| Status | Description |
| --------------- | ------------ |
| verifying | pending verification |
| failed | authentication failed |
| submitted | Submitted |
| reexamine | under review |
| canceled | canceled |
| pass | approved |
| reject | Approval rejected |
| pre-transfer | processing |
| wallet-transfer | Sent |
| wallet-reject | Wallet reject |
| confirmed | block confirmed |
| confirm-error | block confirmation error |
| repealed | revoked |

# Sub-user management

## Introduction

The sub-user management interface provides functions such as creation, query, permission setting, and transfer of sub-users, creation, modification, query, and deletion of API Keys for sub-users, and query of sub-user deposit and withdrawal addresses and balances.

<aside class="notice">Signature authentication is required to access related interfaces of sub-user management. </aside>

The following are the return codes, return messages, and descriptions returned by sub-user-related interfaces.

| Error code | Return message | Description |
| ------ | ------------------------------------------ --------------- | ---------------------------------- |
| 1002 | "forbidden" | Forbidden operations, such as the account is not allowed to create sub-users |
| 1003 | "unauthorized” | Unauthenticated |
| 2002 | invalid field value | parameter error |
| 2014 | number of sub account in the request exceeded valid range | The number of sub accounts has reached the limit |
| 2014 | number of api key in the request exceeded valid range | The number of API Key exceeds the limit |
| 2016 | invalid request while value specified in sub user states | freeze/thaw failure |


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
| ----------- | -------- | ------ | ------------------ ----------------------- | ------ | ----------------- ----------------------------------------------- |
| userList | true | object | | | |
| [{ userName | true | string | Sub-username, an important identification of sub-user identity, requires uniqueness within the platform | NA | A combination of 6 to 20 letters and numbers, which can be pure letters; if a combination of letters and numbers, it needs to be Starts with a letter; letters are not case sensitive; |
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
| ------------- | -------- | -------- | ----------------- --------------------------- | -------- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| [{ userName | true | string | sub-username | |
| note | false | string | sub-user notes (only valid for sub-users with notes) | |
| uid | false | long | Sub-user UID (only valid for successfully created sub-users) | |
| errCode | false | string | Creation failure error code (only valid for sub-users that failed to be created) | |
| errMessage }] | false | string | Error reason for failed creation (only valid for sub-users that failed to be created) | |

## Get the list of sub-users

Through this interface, the parent user can obtain the UID list of all sub-users and the status of each user

API Key permission: read

### HTTP requests

- GET `/v2/sub-user/user-list`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| -------- | -------- | ---- | -------------------------- ------ | ------ | -------- |
| fromId | FALSE | long | Query starting number (only valid for page turning query) | | |

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
| ----------- | -------- | -------- | ---------------- ----------------------- | --------------- |
| code | TRUE | int | status code | |
| message | FALSE | string | error description (if any) | |
| data | TRUE | object | | |
| { uid | TRUE | long | subuser UID | |
| userState } | TRUE | string | Sub-user state | lock, normal |
| nextId | FALSE | long | The start number of next page query (returned only when there is next page data) | |

## Freeze/Unfreeze sub-users

API Key Permissions: Transaction<br>
Frequency limit value (NEW): 20 times/2s

This interface is used by the parent user to freeze and unfreeze the next sub-user

###HTTP requests

- POST `/v2/sub-user/management`

### Request parameters

| Parameter | Required | Data Type | Length | Description | Value Range |
| ------ | -------- | -------- | ---- | ----------- | ------- ----------------- |
| subUid | true | long | - | UID of the sub-user | - |
| action | true | string | - | operation type | lock (freeze), unlock (unfreeze) |

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
| --------- | -------- | -------- | ---- | ---------- | ----- --------------------- |
| subUid | true | long | - | sub-user UID | - |
| userState | true | string | - | Sub-user state | lock (frozen), normal (normal) |


## Get the user status of a specific sub-user

The parent user can obtain the user status of a specific sub-user through this interface

API Key permission: read

### HTTP requests

- GET `/v2/sub-user/user-state`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| -------- | -------- | ---- | --------- | ------ | -------- |
| subUid | TRUE | long | Sub-user UID | | |

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
| ----------- | -------- | -------- | ---------------- | -- ---------- |
| code | TRUE | int | status code | |
| message | FALSE | string | error description (if any) | |
| data | TRUE | object | | |
| { uid | TRUE | long | subuser UID | |
| userState } | TRUE | string | Sub-user state | lock, normal |

##Set sub-user transaction permissions

API Key Permissions: Transactions

This interface is used by the parent user to set the transaction permissions of sub-users in batches.
The sub-user's spot trading authority is enabled by default and does not need to be set.

###HTTP requests

- POST `/v2/sub-user/tradable-market`

### Request parameters

| Parameter | Required | Data Type | Length | Description | Value Range |
| ----------- | -------- | -------- | ---- | -------------- ------------------------------- | ------------------ ---------- |
| subUids | true | string | - | Sub-user UID list (multiple filling is supported, up to 50, separated by commas) | - |
| accountType | true | string | - | account type | isolated-margin,cross-margin |
| activation | true | string | - | account activation status | activated,deactivated |

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

| Parameter | Required | Data Type | Length | Description | Value Range |
| ----------- | -------- | -------- | ---- | -------------- ----------------------------------------------- | ----- ----------------------- |
| code | true | int | - | status code | |
| message | false | string | - | error description (if any) | |
| data | true | object | | | |
| {subUid | true | string | - | sub user UID | - |
| accountType | true | string | - | account type | isolated-margin,cross-margin |
| activation | true | string | - | account activation status | activated,deactivated |
| errCode | false | int | - | Request rejected error code (returned only when the subUid market access permission error is set) | |
| errMessage} | false | string | - | Request rejected error message (returned only when the subUid market access permission is set incorrectly) | |

## Set sub-user asset transfer permission

API Key Permissions: Transactions

This interface is used by the parent user to set the asset transfer permissions of sub-users in batches.
Sub-user's fund transfer authority includes:

- Transfer from a sub-user's spot account to another sub-user's spot account under the same parent user;
- Transfer from the sub-user spot account to the parent user's spot account (no setting is required, it is enabled by default).

###HTTP requests

- POST `/v2/sub-user/transferability`

### Request parameters

| Parameter | Required | Data Type | Length | Description | Value Range |
| ------------- | -------- | -------- | ---- | ------------ --------------------------------- | ---------- |
| subUids | true | string | - | Sub-user UID list (multiple filling is supported, up to 50, separated by commas) | - |
| accountType | false | string | - | account type (if not filled, the default value is spot) | spot |
| transferrable | true | bool | - | transferrable | true,false |

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

| Parameter | Required | Data Type | Length | Description | Value Range |
| ------------- | -------- | -------- | ---- | ------------ ------------------------------------------------- | --- ------- |
| code | true | int | - | status code | |
| message | false | string | - | error description (if any) | |
| data | true | object | | | |
| {subUid | true | long | - | sub user UID | - |
| accountType | true | string | - | account type | spot |
| transferrable | true | bool | - | transferrable | true,false |
| errCode | false | int | - | Request rejected error code (returned only when the subUid market access permission error is set) | |
| errMessage} | false | string | - | Request rejected error message (returned only when the subUid market access permission is set incorrectly) | |

## Get a list of accounts for a specific subuser

Through this interface, the parent user can obtain the Account ID list and the status of each account of a specific sub-user

API Key permission: read

### HTTP requests

- GET `/v2/sub-user/account-list`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| -------- | -------- | ---- | --------- | ------ | -------- |
| subUid | TRUE | long | Sub-user UID | | |

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
| ----------------- | -------- | -------- | ------------- -------------------------------------- | ------------- --------- |
| code | TRUE | int | status code | |
| message | FALSE | string | error description (if any) | |
| data | TRUE | object | | |
| { uid | TRUE | long | subuser UID | |
| list | TRUE | object | | |
| { accountType | TRUE | string | account type | spot, futures, swap |
| activation | TRUE | string | account activation status | activated, deactivated |
| transferrable | FALSE | bool | transferable permission (only valid for accountType=spot) | true, false |
| accountIds | FALSE | object | | |
| { accountId | TRUE | string | account ID | |
| subType | FALSE | string | account subtype (only valid for accountType=isolated-margin) | |
| accountStatus }}} | TRUE | string | account status | normal, locked |

## Sub-user API key creation

This interface is used by the parent user to create the API key of the sub-user

API Key Permissions: Transactions

### HTTP requests

- POST `/v2/sub-user/api-key-generation`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| ----------- | -------- | ------ | ------------------ -------------------------------- | ------ | ----------- -------------------------------------------------- |
| otpToken | true | string | Google verification code of the parent user, the parent user must enable GA secondary verification on the official website page | NA | 6 characters, pure numbers |
| subUid | true | long | sub-user UID | NA | |
| note | ture | string | API key note | NA | Up to 255 characters, unlimited character types |
| permission | true | string | API key permission | NA | Value range: readOnly, trade, among which readOnly must be passed, trade is optional, and the two are separated by a half-width comma. |
| ipAddresses | false | string | The IPv4/IPv6 host address or IPv4 network address bound to the API key | NA | Up to 20 IP addresses, separated by commas, such as: 192.168.1.1,202.106.96.0/24 . If no IP address is bound, the API key is only valid for 90 days. |

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

| Parameter name | Required | Data type | Description | Value range |
| ------------- | -------- | -------- | ----------------- -- | -------- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| { note | true | string | API key note | |
| accessKey | true | string | access key | |
| secretKey | true | string | secret key | |
| permission | true | string | API key permission | |
| ipAddresses } | false | string | IP address bound to the API key | |

## Parent-child user API key information query

This interface is used for the parent user to query its own API key information, and the parent user to query the API key information of sub-users

API Key permission: read

### HTTP requests

- GET `/v2/user/api-key`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| --------- | -------- | ------ | -------------------- --------------------------------------- | ------ | ------ -- |
| uid | true | long | parent user UID, child user UID | NA | |
| accessKey | false | string | the access key of the API key, if default, returns all API keys of the user corresponding to the UID | NA | |

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

| Parameter name | Required | Data type | Description | Value range |
| ------------- | -------- | -------- | ----------------- ------ | ----------------------------- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| [{ accessKey | true | string | access key | |
| note | true | string | API key note | |
| permission | true | string | API key permission | |
| ipAddresses | false | string | IP address bound to the API key | |
| validDays | true | int | API key remaining valid days | If it is -1, it means permanent validity |
| status | true | string | current status of API key | normal (normal), expired (expired) |
| createTime | true | long | API key creation time | |
| updateTime }] | true | long | API key last modification time | |

## Modify sub-user API key

This interface is used by the parent user to modify the API key of the child user

API Key Permissions: Transactions

### HTTP requests

- POST `/v2/sub-user/api-key-modification`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| ----------- | -------- | ------ | ------------------ ---- | ------ | -------------------------------------- ---------------------- |
| subUid | true | long | uid of the sub-user | NA | |
| accessKey | true | string | access key of sub-user API key | NA | |
| note | false | string | API key note | NA | Up to 255 characters |
| permission | false | string | API key permission | NA | Value range: readOnly, trade, where readOnly must be passed, trade is optional, and the two are separated by a half-width comma. |
| ipAddresses | false | string | IP address bound to the API key | NA | IPv4/IPv6 host address or IPv4 network address, up to 20 bindings, multiple IP addresses are separated by half-width commas, such as: 192.168.1.1, 202.106. 96.0/24. If no IP address is bound, the API key is only valid for 90 days. |

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

| Parameter name | Required | Data type | Description | Value range |
| ------------- | -------- | -------- | ----------------- -- | -------- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| { note | false | string | API key note | |
| permission | false | string | API key permission | |
| ipAddresses } | false | string | IP address bound to the API key | |

## Delete sub-user API key

This interface is used by the parent user to delete the API key of the sub-user

API Key Permissions: Transactions

### HTTP requests

- POST `/v2/sub-user/api-key-deletion`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| --------- | -------- | ------ | -------------------- -- | ------ | -------- |
| subUid | true | long | uid of the sub-user | NA | |
| accessKey | true | string | access key of sub-user API key | NA | |

> Response:

```json
{
     "code": 200,
     "data": null
}
```

### Response data

| Parameter name | Required | Data type | Description | Value range |
| -------- | -------- | -------- | ---------------- | ----- --- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |

## Asset transfer (between parent and child users)

API Key Permissions: Transaction<br>
Frequency limit value (NEW): 2 times/2s

The parent user executes the transfer between the parent and child users

### HTTP requests

- POST `/v1/subuser/transfer`

### Request parameters

| Parameter | Required | Data Type | Description | Value Range |
| -------- | -------- | -------- | ------------------- ----------------------------------------- | ----------- -------------------------------------------------- |
| sub-uid | true | long | sub-uid | - |
| currency | true | string | Currency, namely btc, ltc, bch, eth, etc ... (refer to `GET /v1/common/currencys` for value) | - |
| amount | true | decimal | transfer amount | - |
| type | true | string | transfer type | master-transfer-in (sub-user transfers virtual currency to parent user) / master-transfer-out (master user transfers virtual currency to sub-user) |

> Response:

```json
{
   "data": 123456,
   "status": "ok"
}
```

### Response data

| Parameter | Required | Data Type | Length | Description | Value Range |
| ------ | -------- | -------- | ---- | ---------- | -------- ------- |
| data | true | int | - | transfer order id | - |
| status | true | | - | status | "OK" or "Error" |

### error code

| error_code | Description | Type |
| ----------------------------------------------- | ----- --------------------------- | ------ |
| account-transfer-balance-insufficient-error | Insufficient account balance | string |
| base-operation-forbidden | Forbidden operation (parent-child user relationship error reporting) | string |

## Sub-user deposit address query

This node is used by the parent user to query the deposit address of the sub-user's specific currency (except IOTA) in its blockchain, and it is only available to the parent user

API Key permission: read

### HTTP requests

- GET `/v2/sub-user/deposit-address`

### Request parameters

| field name | required | type | description | default value | value range |
| -------- | -------- | ------ | --------- | ------ | ------- -------------------------------------------------- --- |
| subUid | true | long | Sub-user UID | NA | Only 1 |
| currency | true | string | currency | NA | btc, ltc, bch, eth, etc ... (refer to `GET /v1/common/currencys`) |

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

| field name | required | data type | field description | value range |
| ---------- | -------- | -------- | ---------------- | --- ----- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| { currency | true | string | currency | |
| address | true | string | deposit address | |
| addressTag | true | string | deposit address tag | |
| chain } | true | string | chain name | |


## Sub-user deposit record query

This node is used by the parent user to query the recharge records of sub-users, and is only available to the parent user

API Key permission: read

### HTTP requests

- GET `/v2/sub-user/query-deposit`

### Request parameters

| parameter name | data type | required | description |
| --------- | -------- | -------- | ------------------ ----------------------------------- |
| subUid | long | TRUE | Sub-user UID, limit to 1 |
| currency | string | FALSE | currency, default all currencies |
| startTime | long | FALSE | Far point time, retrieved by createTime, see note 1 for value range and default value |
| endTime | long | FALSE | Near point time, retrieved by createTime, see Note 2 for the value range and default value |
| sort | string | FALSE | search direction, asc from far to near, desc from near to far, default value desc |
| limit | int | FALSE | maximum number of items returned in a single page [1,500] (default 100) |
| fromId | long | FALSE | Initial deposit order ID, only valid when querying on the next page, see note 3 |

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
| ------------ | -------- | ---------- | ---------------- ----------------------------------------------- | ----- ------- |
| code | true | int | status code | |
| message | false | string | error description (if any) | |
| data | true | object | | |
| { id | true | long | deposit order id | |
| currency | true | string | currency | |
| txHash | true | string | transaction hash | |
| chain | true | string | chain name | |
| amount | true | bigdecimal | number | |
| address | true | string | address | |
| addressTag | true | string | address tag | |
| state | true | string | state | state see table below |
| createTime | true | long | launch time | |
| updateTime } | true | long | last update time | |
| nextId | false | long | The starting number of the next page (the ID of the deposit order, this field is only included when the query results need to be returned in pages) | |

- Definition of virtual currency recharge status:

| Status | Description |
| ---------- | -------- |
| unknown | status unknown |
| confirming | confirming |
| confirmed | confirmed |
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
| ------ | -------- | -------- | ---- | ---- | -------------- - |
| status | true | | - | status | "OK" or "Error" |
| data | true | list | - | | - |

- data

Parameter|Required | Data Type | Length | Description | Value Range |
-----------|------------|-----------|------------| ----------|--|--
currency| is | string| -|currency|-|
type| is |string| - |account type| spot: spot account |
balance| is | string| -| account balance (sum of available balance and frozen balance) |-|

## Sub-user balance

API Key Permission: Read<br>
Frequency limit value (NEW): 20 times/2s

The parent user queries the balance of each currency account of the sub-user

### HTTP requests

- GET `/v1/account/accounts/{sub-uid}`

### Request parameters

| Parameter | Required | Data Type | Length | Description | Value Range |
| ------- | -------- | -------- | ---- | ------------ | ----- --- |
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

Parameter|Required | Data Type | Length | Description | Value Range |
-----------|------------|-----------|------------| ----------|--|--
id| - |long| - |subuser UID|-|
type| - |string| - |account type| spot: spot account |
list| - |object| - |-|-|

- list

| Parameter | Required | Data Type | Length | Description | Value Range |
| -------- | -------- | -------- | ---- | -------- | -------- ------------------------- |
| currency | - | string | - | currency | - |
| type | - | string | - | account type | trade: trading account, frozen: frozen account |
| balance | - | decimal | - | account balance | - |

# Spot Trading

## Introduction

The spot trading interface provides functions such as order placement, order cancellation, order query, transaction query, and commission rate query.

<aside class="notice">Signature authentication is required to access transaction-related interfaces. </aside>

The following are the return codes and descriptions returned by transaction-related interfaces.
| return code | description |
| -------------------------------------------------- ----------- | -------------------------------------- ---------------------- |
| base-argument-unsupported | A parameter is not supported, please check the parameter |
| base-system-error | System error, if the order is canceled: the order status cannot be found in the cache, the order cannot be canceled; if the order is placed: the order failed to enter the cache, please try again |
| login-required | There is no Signature parameter in the url or the user cannot be found (the key does not correspond to the account id, etc.) |
| parameter-required | Take Profit Stop Loss order lacks parameter stop-price or operator |
| base-record-invalid | No data found yet, please try again later |
| order-amount-over-limit | order quantity over limit |
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
| order-orderstate-error | order state error |
| order-date-limit-error | The query time cannot exceed the system limit |
| order-source-invalid | Invalid order source |
| order-update-error | update data error |
| order-user-cancel-forbidden | The order type is IOC and cancellation is not allowed |
| order-price-greater-than-limit | The order price is higher than the order limit price before the opening, please place a new order |
| order-price-less-than-limit | The order price is lower than the order limit price before the opening, please place a new order |
| order-stop-order-hit-trigger | The stop loss order is triggered by the current price |
| market-orders-not-support-during-limit-price-trading | Market orders are not supported for time-limited orders |
| price-exceeds-the-protective-price-during-limit-price-trading | The price exceeds the protective price during the price limit |
| invalid-client-order-id | client order id duplicated |
| invalid-interval | Query start and end window settings are wrong |
| invalid-start-date | The query start date contains an invalid value |
| invalid-end-date | The query start date contains an invalid value |
| invalid-start-time | The query start time contains invalid values |
| invalid-end-time | Query start time contains invalid value |
| validation-constraints-required | Specified required parameter is missing |
| not-found | The order does not exist when canceling the order |
| base-not-found | Invalid clientorderid canceled too many orders, try again after an hour |

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

| parameter name | data type | required | default value | description |
| --------------- | -------- | -------- | -------- | ------ -------------------------------------------------- ---- |
| account-id | string | true | NA | Account ID, refer to `GET /v1/account/accounts` for value. Spot transactions use the account-id of the 'spot' account |
| symbol | string | true | NA | Trading pair, namely btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for value) |
| type | string | true | NA | order type, including buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker (description see below), buy-stop-limit, sell-stop-limit |
| amount | string | true | NA | Order volume (buy order at market price is the order volume) |
| price | string | false | NA | order price (invalid for market orders) |
| source | string | false | spot-api | Fill in "spot-api" for spot transactions |
| client-order-id | string | false | NA | User-made order number (maximum length 64 characters, must be unique within 24 hours) |
| stop-price | string | false | NA | trigger price of stop-loss order |
| operator | string | false | NA | Take profit stop loss order trigger price operator gte – greater than and equal (>=), lte – less than and equal (<=) |


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

| parameter name | data type | required | default value | description |
| --------------- | -------- | -------- | -------- | ------ -------------------------------------------------- ---- |
| [{ account-id | string | true | NA | Account ID, refer to `GET /v1/account/accounts` for value. Spot transactions use the account-id of the 'spot' account; |
| symbol | string | true | NA | Trading pair, namely btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for value) |
| type | string | true | NA | order type, including buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker (description see below), buy-stop-limit, sell-stop-limit |
| amount | string | true | NA | Order volume (buy order at market price is the order volume) |
| price | string | false | NA | order price (invalid for market orders) |
| source | string | false | spot-api | Fill in "spot-api" for spot transactions |
| client-order-id | string | false | NA | User-made order number (maximum length 64 characters, must be unique within 24 hours) |
| stop-price | string | false | NA | trigger price of stop-loss order |
| operator }] | string | false | NA | Take profit stop order trigger price operator gte – greater than and equal (>=), lte – less than and equal (<=) |

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

| Field Name | Data Type | Description |
| --------------- | -------- | --------------------- ------------ |
| [{ order-id | integer | order number |
| client-order-id | string | User-made order number (if any) |
| err-code | string | Order rejection error code (only valid for rejected orders) |
| err-msg }] | string | Order rejection error message (only valid for rejected orders) |

If the client order ID is reused (within 24 hours), the node returns the order ID and client order ID of the previous order.

## Cancel order

API Key Permissions: Transaction<br>
Frequency limit value (NEW): 100 times/2s

This interface sends a request to cancel an order.

<aside class="warning">This interface only submits cancellation requests, and the actual cancellation results need to be confirmed through interfaces such as order status and matching status. </aside>

### HTTP requests

- POST `/v1/order/orders/{order-id}/submitcancel`


### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| -------- | -------- | ------ | ------------------ | ----- - | -------- |
| order-id | true | string | order ID, fill in the path | | |


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
| ----------- | -------------------------------------- ----------------------- |
| -1 | order was already closed in the long past (order state = canceled, partial-canceled, filled, partial-filled) |
| 5 | partial-canceled |
| 6 | filled |
| 7 | canceled |
| 10 | canceling |

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

| Parameter name | Required | Type | Description | Default value | Value range |
| --------------- | -------- | ------ | -------------- | -- ---- | -------- |
| client-order-id | true | string | user-defined order number | | |


> Response:

```json
{
   "data": "10"
}
```

### Response data

| Field Name | Data Type | Description |
| -------- | -------- | ---------- |
| data | integer | order cancellation status code |

| Status Code | Description |
| ----------- | -------------------------------------- ----------------------- |
| -1 | order was already closed in the long past (order state = canceled, partial-canceled, filled, partial-filled) |
| 0 | client-order-id not found |
| 5 | partial-canceled |
| 6 | filled |
| 7 | canceled |
| 10 | canceling |


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

| parameter name | data type | required | default value | description |
| ---------- | -------- | ----------------------------- ------------------- | ------ | ----------------------- ----------------------------------------- |
| account-id | string | true | NA | Account ID, refer to `GET /v1/account/accounts` for value. Spot transactions use the account-id of the 'spot' account |
| symbol | string | ture | NA | Trading pair, namely btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for value) |
| side | string | false | both | Specify to only return orders in one direction, possible values are: buy, sell. By default, both directions are returned. |
| from | string | false | | query starting ID |
| direct | string | false (if the field 'from' is set, the field 'direct' is required) | | query direction, prev means forward; next means backward |
| size | int | false | 100 | Return the quantity of the order, the maximum value is 500. |

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

| Field Name | Data Type | Description |
| ------------------ | -------- | --------------------- ------------------------------------------ |
| id | integer | order id, no order of size, can be used as the from field of the next page turning query request |
| client-order-id | string | User-made order number (all open orders can return client-order-id) |
| symbol | string | trading pair, such as btcusdt, ethbtc |
| price | string | transaction price of limit order |
| created-at | int | Timestamp of order creation adjusted to Singapore time, in milliseconds |
| type | string | order type |
| filled-amount | string | Amount of the filled part of the order |
| filled-cash-amount | string | The total price of the filled portion of the order |
| filled-fees | string | Total transaction fees paid |
| source | string | Fill in "api" for spot transactions |
| state | string | order status, including submitted, partial-filled, canceling, created |
| stop-price | string | trigger price of stop loss order |
| operator | string | The trigger price operator for stop loss orders |

## Cancel orders in batches (open orders)

API Key Permissions: Transaction<br>
Frequency limit value (NEW): 50 times/2s

This interface sends a request to cancel orders in batches.

<aside class="warning">This interface only submits cancellation requests, and the actual cancellation results need to be confirmed through interfaces such as order status and matching status. </aside>

### HTTP requests

- POST `/v1/order/orders/batchCancelOpenOrders`


### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| ---------- | -------- | ------ | ------------------- ----------------------------------------- | ------ | ---- ------------------------------------------------ |
| account-id | false | string | account ID, refer to `GET /v1/account/accounts` | | |
| symbol | false | string | list of transaction symbols (up to 10 symbols, multiple transaction symbols separated by commas), btcusdt, ethbtc... (refer to `/v1/common/symbols` for values) | all | |
| side | false | string | Active trading direction | | "buy" or "sell", by default all orders that meet the conditions and have not been executed will be returned |
| size | false | int | number of records to be returned | 100 | [0,100] |


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


| Parameter name | Required | Data type | Description | Value range |
| ------------- | -------- | -------- | ----------------- --------- | -------- |
| success-count | true | int | number of successfully canceled orders | |
| failed-count | true | int | number of failed orders | |
| next-id | true | long | the next order number that meets the cancellation criteria | |

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

| Parameter name | Required | Type | Description | Default value | Value range |
| ---------------- | -------- | -------- | -------------- ------------------------------------------------- | --- --- | ------------------ |
| order-ids | false | string[] | order ID list (order-ids and client-order-ids must and can only be filled in, no more than 50 orders) | | no more than 50 orders at a time |
| client-order-ids | false | string[] | A list of user-made order numbers (order-ids and client-order-ids must be selected and filled in, and no more than 50 orders) | | No more than 50 single orders orders |

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

| Field Name | Data Type | Description |
| --------- | -------- | --------------------------- --------------------------------- |
| { success | string[] | List of successfully canceled orders (can be order-id list or client-order-id list, subject to user request) |
| failed } | string[] | List of failed orders (can be order-id list or client-order-id list, subject to user request) |

Cancellation failed order list -

| Field Name | Data Type | Description |
| --------------- | -------- | --------------------- --------------------------------------- |
| [{ order-id | string | order number (if the user includes order-id when creating an order, this field must also be included in the return) |
| client-order-id | string | User-made order number (if the user includes client-order-id when creating an order, this field must also be included in the return) |
| err-code | string | Order rejection error code (only valid for rejected orders) |
| err-msg | string | Order rejected error message (only valid for rejected orders) |
| order-state }] | string | current order state (if any) |

In the returned field list, the possible values of order-state include -

| order-state | Description |
| ----------- | -------------------------------------- ----------------------- |
| -1 | order was already closed in the long past (order state = canceled, partial-canceled, filled, partial-filled) |
| 5 | partial-canceled |
| 6 | filled |
| 7 | canceled |
| 10 | canceling |

## Query order details

API Key Permission: Read<br>
Frequency limit value (NEW): 50 times/2s

This interface returns the latest status and details of the specified order. Orders created through the API cannot be queried after being canceled for more than 2 hours.

### HTTP requests

- GET `/v1/order/orders/{order-id}`


### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| -------- | -------- | ------ | ------------------ | ----- - | -------- |
| order-id | true | string | order ID, fill in the path | | |

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

| Field name | Required | Data type | Description | Value range |
| ----------------- | -------- | -------- | ------------- -------------------------------------------------- | -- -------------------------------------------------- -------- |
| account-id | true | long | account ID | |
| amount | true | string | order quantity | |
| canceled-at | false | long | order cancellation time | |
| created-at | true | long | order creation time | |
| field-amount | true | string | Transaction amount | |
| field-cash-amount | true | string | total transaction amount | |
| field-fees | true | string | transaction fee (buy for coins, sell for money) | |
| finished-at | false | long | The time when the order becomes finalized, not the transaction time, including the "cancelled" status | |
| id | true | long | order ID | |
| client-order-id | false | string | user-defined order number (all open orders can return client-order-id (if any); only closed orders within 7 days (based on order creation time) (state <> canceled) Can return client-order-id (if any); Only closed orders (state = canceled) within 24 hours (based on order creation time) can return client-order-id (if any) | |
| price | true | string | order price | |
| source | true | string | order source | api |
| state | true | string | order status | submitted, partial-filled, partially-canceled, partially-canceled, filled, canceled, created |
| symbol | true | string | trading pair | btcusdt, ethbtc, rcneth ... |
| type | true | string | order type | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc : IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| stop-price | false | string | trigger price of stop-loss order | |
| operator | false | string | stop loss order trigger price operator | gte,lte |


## Query order details (based on client order ID)

API Key Permission: Read<br>
Frequency limit value (NEW): 50 times/2s

This interface returns the latest order status and details of the specified user-defined order number (within 24 hours). Orders created through the API cannot be queried after being canceled for more than 2 hours.

### HTTP requests

- GET `/v1/order/orders/getClientOrder`

### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| ------------- | -------- | ------ | -------------- | ---- -- | -------- |
| clientOrderId | true | string | user-defined order number | | |

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

| Field name | Required | Data type | Description | Value range |
| ----------------- | -------- | -------- | ------------- -------------------------------------------------- | -- -------------------------------------------------- -------- |
| account-id | true | long | account ID | |
| amount | true | string | order quantity | |
| canceled-at | false | long | order cancellation time | |
| created-at | true | long | order creation time | |
| field-amount | true | string | Transaction amount | |
| field-cash-amount | true | string | total transaction amount | |
| field-fees | true | string | transaction fee (buy for coins, sell for money) | |
| finished-at | false | long | The time when the order becomes finalized, not the transaction time, including the "cancelled" status | |
| id | true | long | order ID | |
| client-order-id | false | string | user-defined order number (only orders within 24 hours (based on order creation time) can be queried.) | |
| price | true | string | order price | |
| source | true | string | order source | api |
| state | true | string | order status | submitted, partial-filled, partially-canceled, partially-canceled, filled, canceled, created |
| symbol | true | string | trading pair | btcusdt, ethbtc, rcneth ... |
| type | true | string | order type | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc : IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| stop-price | false | string | trigger price of stop-loss order | |
| operator | false | string | stop loss order trigger price operator | gte,lte |

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

| Parameter name | Required | Type | Description | Default value | Value range |
| -------- | -------- | ------ | ------------------ | ----- - | -------- |
| order-id | true | string | order ID, fill in the path | | |


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

| Field name | Required | Data type | Description | Value range |
| ------------------- | -------- | -------- | ----------- -------------------------------------------------- | -------------------------------------------------- ---------- |
| created-at | true | long | transaction timestamp timestamp | |
| filled-amount | true | string | filled amount | |
| filled-fees | true | string | transaction fee (positive value) or transaction rebate (negative value) | |
| fee-currency | true | string | transaction fee or transaction rebate currency (the transaction fee currency for buy orders is the base currency, the transaction fee currency for sell orders is the pricing currency; the transaction rebate currency for buy orders is the pricing currency, and the transaction rebate currency of the sell order is the base currency) | |
| id | true | long | order transaction record ID | |
| match-id | true | long | Matching ID, the order ID of order execution in matching | |
| order-id | true | long | order ID, the ID of the order to which the transaction belongs | |
| trade-id | false | integer | Unique trade ID (NEW) Unique trade ID, the unique ID generated at the time of trade | |
| price | true | string | transaction price | |
| source | true | string | order source | api |
| symbol | true | string | trading pair | btcusdt, ethbtc, rcneth ... |
| type | true | string | order type | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc : IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| role | true | string | transaction role | maker,taker |
| filled-points | true | string | deduction amount (can be ht or hbpoint) | |
| fee-deduct-currency | true | string | deduction type | If it is empty, it means that the deduction fee is the original currency; it means that the deduction fee is the deduction asset |
| fee-deduct-state | true | string | deduction status | deduction in progress: ongoing, deduction completed: done |

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

| Parameter name | Required | Type | Description | Default value | Value range |
| ---------- | -------- | ------ | ------------------- ----------------------------------------- | ----------- ---------------- | --------------------------------- ------------------------------ |
| symbol | true | string | trading pair | | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |
| types | false | string | Combinations of order types to query, separated by commas | | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy- ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| start-time | false | long | query start time, the time format is UTC time in millisecond. Query based on order generation time | -48h 48 hours before the query end time | Value range [((end-time) – 48h), (end-time)], the maximum query window is 48 hours, and the window translation range is the nearest For 180 days, the translation range of the query window for historical orders that have been completely canceled is only the last 2 hours (state="canceled") |
| end-time | false | long | Query end time, the time format is UTC time in millisecond. Query based on order generation time | present | value range [(present-179d), present], the maximum query window is 48 hours, the window translation range is the last 180 days, and the query window translation range of completely canceled historical orders is only the latest 2 hours (state="canceled") |
| start-date | false | string | query start date, date format yyyy-mm-dd. Query based on the order generation time | -1d 1 day before the query end date | Value range [((end-date) – 1), (end-date)], the maximum query window is 2 days, and the window translation range is the nearest For 180 days, the translation range of the query window for historical orders that have been completely canceled is only the last 2 hours (state="canceled") |
| end-date | false | string | Query end date, date format yyyy-mm-dd. Query based on order generation time | today | value range [(today-179), today], the maximum query window is 2 days, the window translation range is the last 180 days, and the query window translation range of completely canceled historical orders is only the latest 2 hours (state="canceled") |
| states | true | string | Combination of order states to query, separated by ',' |
| from | false | string | Query start ID | | If it is a backward query, it will be assigned the last id obtained in the last query result; if it is a forward query, it will be assigned the first id obtained in the last query result an id |
| direct | false | string | query direction | | prev forward; next backward |
| size | false | string | query record size | 100 | [1, 100] |


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

| Parameter name | Required | Data type | Description | Value range |
| ----------------- | -------- | -------- | ------------- -------------------------------------------------- | -- -------------------------------------------------- -------- |
| account-id | true | long | account ID | |
| amount | true | string | order quantity | |
| canceled-at | false | long | The time when the cancellation request was received | |
| created-at | true | long | order creation time | |
| field-amount | true | string | Transaction amount | |
| field-cash-amount | true | string | total transaction amount | |
| field-fees | true | string | transaction fee (buying is base currency, selling is price currency) | |
| finished-at | false | long | Last transaction time | |
| id | true | long | order ID, no order of size, can be used as the from field of the next page turning query request | |
| client-order-id | false | string | user-defined order number (all open orders can return client-order-id (if any); only closed orders within 7 days (based on order creation time) (state <> canceled) Can return client-order-id (if any); only closed orders (state = canceled) within 24 hours (based on order creation time) can be queried) | |
| price | true | string | order price | |
| source | true | string | order source | api |
| state | true | string | order status | submitted, partial-filled, partially-canceled, partially-canceled, filled, canceled, created |
| symbol | true | string | trading pair | btcusdt, ethbtc, rcneth ... |
| type | true | string | order type| submit-cancel: the order cancellation application has been submitted, buy-market: buy at the market price, sell-market: sell at the market price, buy-limit: buy at the limit price, sell-limit: sell at the limit price, buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| stop-price | false | string | trigger price of stop-loss order | |
| operator | false | string | stop loss order trigger price operator | gte,lte |

### start-date, end-date related error codes

| Error code | Corresponding error scenario |
| ------------------ | ------------------------------ --------------------------------- |
| invalid_interval | start date is less than end date; or the time interval between start date and end date is greater than 2 days |
| invalid_start_date | start date is a date 180 days ago; or start date is a date in the future |
| invalid_end_date | end date is a date 180 days ago; or end date is a date in the future |

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

| Parameter name | Required | Type | Description | Default value | Value range |
| ---------- | -------- | ------ | ------------------- ----------------------------------------- | ----------- --- | ---------------------------------------------- -------- |
| symbol | false | string | trading pair | all | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |
| start-time | false | long | query start time (inclusive) | time 48 hours ago | UTC time in millisecond |
| end-time | false | long | query end time (inclusive) | query time | UTC time in millisecond |
| direct | false | string | order query direction (Note: it only works when the total number of retrieved items exceeds the limit of the size field; if the total number of retrieved items is within the limit of the size field, the direct field does not work.) | next | prev forward, next backward |
| size | false | int | number of items returned each time | 100 | [10,1000] |


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

| Parameter name | Required | Data type | Description | Value range |
| ----------------- | -------- | -------- | ------------- -------------------------------------------------- | -- -------------------------------------------------- -------- |
| {account-id | true | long | account ID | |
| amount | true | string | order quantity | |
| canceled-at | false | long | The time when the cancellation request was received | |
| created-at | true | long | order creation time | |
| field-amount | true | string | Transaction amount | |
| field-cash-amount | true | string | total transaction amount | |
| field-fees | true | string | transaction fee (buying is base currency, selling is price currency) | |
| finished-at | false | long | Last transaction time | |
| id | true | long | order ID, no size order | |
| client-order-id | false | string | user-defined order number (only closed orders (state <> canceled) within 48 hours (based on order creation time) can return client-order-id (if any); only 24 Closed orders (state = canceled) within hours (based on order creation time) can be queried) | |
| price | true | string | order price | |
| source | true | string | order source | api |
| state | true | string | order status | partial-canceled partially cancelled, filled completely completed, canceled canceled |
| symbol | true | string | trading pair | btcusdt, ethbtc, rcneth ... |
| stop-price | false | string | trigger price of stop-loss order | |
| operator | false | string | stop loss order trigger price operator | gte,lte |
| type} | true | string | order type | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell- ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-limit-maker, sell-limit-maker |
| next-time | false | long | Next query start time (valid when the request field "direct" is "prev"), next query end time (valid when the request field "direct" is "next"). Note: This return field exists only when the total number of items retrieved exceeds the limit of the size field. | UTC time in milliseconds |
## Current and historical transactions

API Key Permission: Read<br>
Frequency limit value (NEW): 20 times/2s

This interface queries current and historical transaction records based on search criteria.

### HTTP requests

- GET `/v1/order/matchresults`


### Request parameters

| Parameter name | Required | Type | Description | Default value | Value range |
| ---------- | -------- | ------ | ------------------- ------------------------ | ----------------------- | - -------------------------------------------------- --------- |
| symbol | true | string | trading pair | N/A | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |
| types | false | string | Combination of order types to query, separated by ',' | all | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price , buy-ioc: IOC buy order, sell-ioc: IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| start-date | false | string | Query start date (Singapore time zone) date format yyyy-mm-dd | -1d 1 day before the query end date | Range of values [((end-date) – 1), (end -date)] , the maximum query window is 2 days, and the window translation range is the last 61 days. |
| end-date | false | string | query end date (Singapore time zone), date format yyyy-mm-dd | today | value range [(today-60), today], the maximum query window is 2 days, and the window translation range for the last 61 days |
| from | false | string | Query start ID | N/A | If it is a backward query, it will be assigned the last id (not trade-id) obtained in the last query result; if it is a forward query, it will be assigned It is the first id (not trade-id) obtained in the last query result |
| direct | false | string | query direction | next | prev forward; next backward |
| size | false | string | query record size | 100 | [1, 500] |

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

| Parameter name | Required | Data type | Description | Value range |
| ------------------- | -------- | -------- | ----------- -------------------------------------------------- | -------------------------------------------------- ---------- |
| created-at | true | long | transaction timestamp timestamp | |
| filled-amount | true | string | filled amount | |
| filled-fees | true | string | transaction fee (positive value) or transaction rebate (negative value) | |
| fee-currency | true | string | transaction fee or transaction rebate currency (the transaction fee currency for buy orders is the base currency, the transaction fee currency for sell orders is the pricing currency; the transaction rebate currency for buy orders is the pricing currency, and the transaction rebate currency of the sell order is the base currency) | |
| id | true | long | order transaction record ID, no order of size, can be used as the from field of the next page turning query request | |
| match-id | true | long | matching ID | |
| order-id | true | long | order ID | |
| trade-id | false | integer | unique transaction ID | |
| price | true | string | transaction price | |
| source | true | string | order source | api |
| symbol | true | string | trading pair | btcusdt, ethbtc, rcneth ... |
| type | true | string | order type | buy-market: buy at market price, sell-market: sell at market price, buy-limit: buy at limit price, sell-limit: sell at limit price, buy-ioc: IOC buy order, sell-ioc : IOC sell order, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| role | true | string | transaction role | maker,taker |
| filled-points | true | string | deduction amount (can be ht or hbpoint) | |
| fee-deduct-currency | true | string | deduction type | |
| fee-deduct-state | true | string | deduction status | deduction in progress: ongoing, deduction completed: done |

Note: <br>

- The transaction rebate amount in filled-fees may not arrive in real time;<br>
### start-date, end-date related error codes

| Error code | Corresponding error scenario |
| ------------------ | ------------------------------ --------------------------------- |
| invalid_interval | start date is less than end date; or the time interval between start date and end date is greater than 2 days |
| invalid_start_date | start date is a date 61 days ago; or start date is a date in the future |
| invalid_end_date | end date is a date 61 days ago; or end date is a date in the future |


## Get the user's current transaction fee rate

Api users can query the transaction pair rate, and there is a limit of 10 transaction pairs at a time, and the rate of sub-users is consistent with that of the parent user

API Key permission: read

```shell
curl "https://api.bitv.com/v2/reference/transact-fee-rate?symbols=btcusdt,ethusdt,ltcusdt"
```

### HTTP requests

- GET `/v2/reference/transact-fee-rate`

### Request parameters

| parameter | data type | required | default value | description | value range |
| ------- | -------- | -------- | ------ | ---------------- -------- | ----------------------------------------- -------------- |
| symbols | string | true | NA | Trading pairs, multiple fields are allowed, separated by commas | btcusdt, ethbtc... (refer to `GET /v1/common/symbols` for values) > |


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

| Field Name | Data Type | Description |
| ----------------- | -------- | ---------------------- ----------------------------------------- |
| code | integer | status code |
| message | string | error description (if any) |
| data | object | |
| { symbol | string | transaction code |
| makerFeeRate | string | Base fee rate - passive party, if transaction fee rebate is applicable, return rebate rate (negative value) |
| takerFeeRate | string | base fee rate - active side |
| actualMakerRate | string | Fee rate after deduction - passive party, if the deduction is not applicable or deduction is not enabled, return the basic rate; if the transaction fee rebate is applicable, return the rebate rate (negative value) |
| actualTakerRate } | string | Rate after deduction – the active party, if the deduction is not applicable or deduction is not enabled, the basic rate will be returned |

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

| Error Code | Error Message | Description |
| ----------- | -------------------------------------- - | ------------------------ |
| bad-request | invalid topic | topic error |
| bad-request | invalid symbol | symbol error |
| bad-request | symbol trade not open now | The trading pair has not yet started trading |
| bad-request | 429 too many request | req request is too frequent |
| bad-request | unsub with not subbed topic |
| bad-request | not json string | The request sent is not in JSON format |
| 1008 | header required correct cloud-exchange | exchangeCode parameter error |
| bad-request | request timeout | request timeout |

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
```### parameters

| parameter | data type | required | description | value range |
| ------ | -------- | -------- | -------- | --------------- ------------------------------------------------ |
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
```### Data update field list

| Field | Data Type | Description |
| ------ | -------- | ------------------------------ ---------- |
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

| parameter | data type | required | default value | description | value range |
| ---- | -------- | -------- | -------------------------- ----------- | -------------------------------- | ------ -------------------------------------------------- ---- |
| from | integer | false | 1501174800(2017-07-28T00:00:00+08:00) | start time (epoch time in second) | [1501174800, 2556115200] |
| to | integer | false | 2556115200(2050-01-01T00:00:00+08:00) | end time (epoch time in second) | [1501174800, 2556115200] or ($from, 2556115200] if "from" is set |
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
| ------ | -------- | -------- | ------ | ------------ | ---- -------------------------------------------------- |
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

| Field | Data Type | Description |
| ------- | -------- | ---------------------------- |
| bids | object | all current bids [price, size] |
| asks | object | all current ask orders [price, size] |
| version | integer | internal field |
| ts | integer | Timestamp of Singapore time in milliseconds |

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

```In the future, the data behavior of the 150-level incremental push will be consistent with that of the 5-level/20-level increment, that is, when the unilateral market depth changes, the push message will not include the other side's market depth;<br>
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

```However, the 5-level/20-level MBP is incremented one by one, and no data is pushed when the order book does not change;<br>
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
| ------ | -------- | -------- | ------ | ----------------- ----------- | -----------------------------------|
| symbol | string | true | NA | transaction code (wildcards are not supported) | |
| levels | integer | true | NA | depth level (value: 5, 20, 150) | currently only supports 5 levels, 20 levels, or 150 levels of depth |

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

| Field | Data Type | Description |
| ---------- | -------- | ----------------------------- ---------- |
| seqNum | integer | message sequence number |
| prevSeqNum | integer | sequence number of the previous message |
| bids | object | bids, sorted by price in descending order, ["price","size"] |
| asks | object | Ask orders, sorted by price in ascending order, ["price","size"] |

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
| ------ | -------- | -------- | ------ | ----------------- ------- | -------- |
| symbol | string | true | NA | transaction code (wildcards are not supported) | |
| levels | integer | true | NA | depth level | 5,10,20 |

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

| Field | Data Type | Description |
| ------ | -------- | ------------------------------ ------ |
| seqNum | integer | message sequence number |
| bids | object | bids, sorted by price in descending order, ["price","size"] |
| asks | object | Ask orders, sorted by price in ascending order, ["price","size"] |


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

| parameter | data type | required | default value | description | value range |
| ------ | -------- | -------- | ------ | -------- | -------- ---------------------------------------------- |
| symbol | string | true | NA | transaction symbol | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |

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
| --------- | -------- | ------------ |
| symbol | string | transaction code |
| quoteTime | long | Handicap update time |
| bid | float | buy price |
| bidSize | float | buy a quantity |
| ask | float | Ask price |
| askSize | float | sell a quantity |
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

| parameter | data type | required | default value | description | value range |
| ------ | -------- | -------- | ------ | -------- | -------- ---------------------------------------------- |
| symbol | string | true | NA | transaction symbol | btcusdt, ethbtc... (value reference `GET /v1/common/symbols`) |

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
| --------- | -------- | --------------------------- ---------------- |
| id | integer | unique transaction ID (will be discarded) |
| tradeId | integer | unique transaction ID (NEW) |
| amount | float | volume (buy or sell side) |
| price | float | transaction price |
| ts | integer | transaction time (UNIX epoch time in millisecond) |
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

| parameter | data type | required | default value | description | value range |
| ------ | -------- | -------- | ------ | -------- | -------- ------------ |
| symbol | string | true | NA | transaction symbol | btcusdt, ethbtc...etc. |

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
| id | integer | unix time, also used as message ID |
| amount | float | 24-hour trading volume |
| count | integer | Number of transactions in 24 hours |
| open | float | 24-hour opening price |
| close | float | Latest Price |
| low | float | 24 hours lowest price |
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
| sub | Subscription Data |
| req | data request |
| ping, pong | heartbeat data |
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

| field | required | data type | description |
| ---------------- | -------- | -------- | -------------- ---------------------------------------------- |
| action | true | string | Websocket data operation type, the authentication fixed value is req |
| ch | true | string | request subject, the fixed value of authentication is auth |
| authType | true | string | Authentication type, the fixed value of authentication is api. Note that this parameter is not included in the signature calculation. |
| accessKey | true | string | AccessKey in the API Key you applied for |
| signatureMethod | true | string | signature method, the protocol for users to calculate the signature message hash, the fixed value is HmacSHA256 |
| signatureVersion | true | string | Signature protocol version, the fixed value is 2.1 |
| timestamp | true | string | Timestamp, the time (UTC time) when you make the request. Including this value in the query request helps prevent third parties from intercepting your request. Such as: 2017-05-11T16:22:06. Again yes (UTC time zone) |
| signature | true | string | signature, a computed value used to ensure that the signature is valid and has not been tampered with |

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

| Error Code | Error Message | Description |
| ------ | ------------------------ | ----------------- ------------------------------ |
| 200 | True | True returns |
| 100 | timeout off | timeout off |
| 400 | Bad Request | Bad request |
| 404 | Not Found | Service not found |
| 429 | Too Many Requests | Exceeded the maximum number of connections for a single server or exceeded the maximum number of connections for a single IP |
| 500 | System exception | System error |
| 2000 | invalid.ip | invalid ip |
| 2001 | nvalid.json | invalid request json |
| 2001 | invalid.authType | Signature verification method error |
| 2001 | invalid.action | Invalid subscription event |
| 2001 | invalid.symbol | invalid trading pair |
| 2001 | invalid.ch | invalid subscription |
| 2001 | invalid.exchange | Invalid exchange code |
| 2001 | missing.param.auth | missing signature verification parameters |
| 2002 | invalid.auth.state | Authentication failed |
| 2002 | auth.fail | Signature verification failed |
| 2003 | query.account.list.error | Failed to query account list |
| 4000 | too.many.request | Client uplink request frequency limit |
| 4000 | too.many.connection | Number of connections with the same key |

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

| Field | Data Type | Description |
| ------------- | -------- | -------------------------- ------------------------------------- |
| eventType | string | event type, valid value: trigger (this event is only valid for plan order/track order) |
| symbol | string | transaction code |
| clientOrderId | string | User-defined order number |
| orderSide | string | order direction, valid values: buy, sell |
| orderStatus | string | order status, valid value: rejected |
| errCode | int | Order trigger failure error code |
| errMessage | string | Error message for order trigger failure |
| lastActTime | long | Order trigger failure time |

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

| Field | Data Type | Description |
| ------------- | -------- | -------------------------- ------------------------------------- |
| eventType | string | Event type, valid value: deletion (this event is only valid for plan order/tracking order) |
| symbol | string | transaction code |
| clientOrderId | string | User-defined order number |
| orderSide | string | order direction, valid values: buy, sell |
| orderStatus | string | order status, valid value: canceled |
| lastActTime | long | order cancellation time |

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

| Field | Data Type | Description |
| --------------- | -------- | --------------------- --------------------------------------- |
| eventType | string | event type, valid value: creation |
| symbol | string | transaction code |
| accountId | long | account ID |
| orderId | long | order ID |
| clientOrderId | string | User-made order number (if any) |
| orderPrice | string | order price |
| orderSize | string | order size (invalid for market buy orders) |
| orderValue | string | order amount (only valid for market buy orders) |
| type | string | order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell-limit-maker, buy-ioc, sell-ioc |
| orderStatus | string | order status, valid value: submitted |
| orderCreateTime | long | order creation time |

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

| Field | Data Type | Description |
| ------------- | -------- | -------------------------- ------------------------------------- |
| eventType | string | event type, valid value: trade |
| symbol | string | transaction code |
| tradePrice | string | traded price |
| tradeVolume | string | trade volume |
| orderId | long | order ID |
| type | string | order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell-limit-maker, buy-ioc, sell-ioc |
| clientOrderId | string | User-made order number (if any) |
| tradeId | long | trade ID |
| tradeTime | long | trade time |
| aggressor | bool | Whether to be the active party of the transaction, valid values: true (taker), false (maker) |
| orderStatus | string | order status, valid values: partial-filled, filled |
| remainAmt | string | unexecuted quantity (buy order at market price is the unexecuted amount) |
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

| Field | Data Type | Description |
| ------------- | -------- | -------------------------- ------------------------------------- |
| eventType | string | event type, valid value: cancellation |
| symbol | string | transaction code |
| orderId | long | order ID |
| type | string | order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell-limit-maker, buy-ioc, sell-ioc |
| clientOrderId | string | User-made order number (if any) |
| orderStatus | string | order status, valid values: partial-canceled, canceled |
| remainAmt | string | unexecuted quantity (buy order at market price is the unexecuted amount) |
| lastActTime | long | Last update time of the order |

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
| ------ | -------- | -------- | ------------------------ --------------------------------------- |
| symbol | string | TRUE | transaction code (support wildcard * ) |
| mode | int | FALSE | push mode (0 - push only when the order is completed; 1 - push both when the order is completed and canceled; default value: 0) |

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
| --------------- | -------- | --------------------- --------------------------------------- |
| eventType | string | event type (trade) |
| symbol | string | transaction code |
| orderId | long | order ID |
| tradePrice | string | traded price |
| tradeVolume | string | trade volume |
| orderSide | string | order direction, valid values: buy, sell |
| orderType | string | order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker, buy-stop -limit,sell-stop-limit |
| aggressor | bool | Whether to be the active party of the transaction, valid values: true, false |
| tradeId | long | trade ID |
| tradeTime | long | trade time, unix time in millisecond |
| transactFee | string | Transaction fee (positive value) or transaction fee rebate (negative value) |
| feeCurrency | string | Transaction fee or transaction fee rebate currency (the transaction fee currency for buy orders is the base currency, the transaction fee currency for sell orders is the pricing currency; the transaction fee rebate currency for buy orders is the denominated currency, and the transaction fee rebate currency for the sell order is the base currency) |
| feeDeduct | string | Transaction fee deduction |
| feeDeductType | string | transaction fee deduction type, valid values: ht, point |
| accountId | long | Account ID |
| source | string | order source |
| orderPrice | string | order price (the market price order does not have this field) |
| orderSize | string | order quantity (the market price buy order does not have this field) |
| orderValue | string | order amount (only market buy orders have this field) |
| clientOrderId | string | User-defined order number |
| stopPrice | string | Order trigger price (this field is only available for stop-loss orders) |
| operator | string | order trigger direction (only take profit and stop loss orders have this field) |
| orderCreateTime | long | order creation time |
| orderStatus | string | order status, valid values: filled, partial-filled |

Note: <br>

- The transaction rebate amount in transactFee may not arrive in real time;<br>

### Data update field list (when the order is canceled)

| Field | Data Type | Description |
| --------------- | -------- | --------------------- --------------------------------------- |
| eventType | string | event type (cancellation) |
| symbol | string | transaction code |
| orderId | long | order ID |
| orderSide | string | order direction, valid values: buy, sell |
| orderType | string | order type, valid values: buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker, buy-stop -limit,sell-stop-limit |
| accountId | long | Account ID |
| source | string | order source |
| orderPrice | string | order price (the market price order does not have this field) |
| orderSize | string | order quantity (the market price buy order does not have this field) |
| orderValue | string | order amount (only market buy orders have this field) |
| clientOrderId | string | User-defined order number |
| stopPrice | string | Order trigger price (this field is only available for stop-loss orders) |
| operator | string | order trigger direction (only take profit and stop loss orders have this field) |
| orderCreateTime | long | order creation time |
| remainAmt | string | open volume (for market buy orders, this field is defined as unfilled volume) |
| orderStatus | string | order status, valid values: canceled, partial-canceled |

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
| ----------- | -------- | ---------------------------- ----------------------------------- |
| currency | string | currency |
| accountId | long | account ID |
| balance | string | account balance (only pushed when the account balance changes) |
| available | string | available balance (only pushed when the available balance changes) |
| changeType | string | Balance change type, valid values: order-place (order creation), order-match (order transaction), order-refund (order transaction refund), order-cancel (order cancellation), order-fee- refund (deduct transaction fee) |
| accountType | string | account type, valid values: trade, frozen, loan, interest |
| changeTime | long | balance change time, unix time in millisecond |

Note: <br>
The account update pushes the amount received, and multiple transaction rebates generated by multiple transactions may be combined into the account.

<br>
<br>
<br>
<br>
<br>
