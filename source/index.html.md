---
title: BitV API 文檔

language_tabs: # must be one of https://git.io/vQNgJ
  - json

toc_footers:
  - <a href='https://www.bitv.com/api/'>創建 API Key </a>
includes:

search: false

---


# 簡介

## API 簡介

歡迎使用BitV API！  

此文檔是BitV的唯一官方API文檔，提供的功能和服務會在此持續更新，請大家及時關注。  

您可以通過點擊上方菜單來切換獲取不同業務的API，還可通過點擊右上方的語言按鈕來切換文檔語言。  

文檔右側是請求參數以及響應結果的示例。

## 更新訂閱

關於API新增、更新、下線等信息會提前發佈公告進行通知，建議您關注和訂閱我們的公告，及時獲取相關信息。  


## 聯繫我們

API 使用中如有疑問或咨詢事項，請參考`咨詢事項 Q&A`進行咨詢。

# 快速入門

## 接入準備

如需使用API ，請先登錄網頁端，完成API key的申請和權限配置，再據此文檔詳情進行開發和交易。  

您可以點擊<a href='https://www.bitv.com/api/'>這裡 </a> 創建 API Key。

每個母用戶可創建20組Api Key，每個Api Key可對應設置讀取、交易、提幣三種權限。  

權限說明如下：

- 讀取權限：讀取權限用於對數據的查詢接口，例如：訂單查詢、成交查詢等。
- 交易權限：交易權限用於下單、撤單、划轉類接口。
- 提幣權限：提幣權限用於創建提幣訂單、取消提幣訂單操作。

創建成功後請務必記住以下信息：

- `Access Key`  API 訪問密鑰

- `Secret Key`  簽名認證加密所使用的密鑰（僅申請時可見）

<aside class="notice">
每個 API Key 最多可綁定 20個IP 地址(主機地址或網絡地址)，未綁定 IP 地址的 API Key 有效期為90天。出於安全考慮，強烈建議您綁定 IP 地址。
</aside>
<aside class="warning">
<red><b>風險提示</b></red>：這兩個密鑰與賬號安全緊密相關，無論何時都請勿將二者<b>同時</b>向其它人透露。API Key的洩露可能會造成您的資產損失（即使未開通提幣權限），若發現API Key洩露請盡快刪除該API Key。
</aside> 



## 接口類型

我們為用戶提供兩種接口，您可根據自己的使用場景和偏好來選擇適合的方式進行查詢行情、交易或提幣。  

### REST API

REST，即Representational State Transfer的縮寫，是目前較為流行的基於HTTP的一種通信機制，每一個URL代表一種資源。

交易或資產提幣等一次性操作，建議開發者使用REST API進行操作。

### WebSocket API

WebSocket是HTML5一種新的協議（Protocol）。它實現了客戶端與服務器全雙工通信，通過一次簡單的握手就可以建立客戶端和服務器連接，服務器可以根據業務規則主動推送信息給客戶端。

市場行情和買賣深度等信息，建議開發者使用WebSocket API進行獲取。

**接口鑒權**

以上兩種接口均包含公共接口和私有接口兩種類型。

公共接口可用於獲取基礎信息和行情數據。公共接口無需認證即可調用。

私有接口可用於交易管理和賬戶管理。每個私有請求必須使用您的API Key進行簽名驗證。

## 接入URLs


**REST API**

**`https://api.bitv.com`**  

**Websocket Feed（行情，不包含MBP增量行情）**

**`wss://api.bitv.com/ws`**  

**Websocket Feed（行情，僅MBP增量行情）**

**`wss://api.bitv.com/feed`**  

**Websocket Feed（資產和訂單）**

**`wss://api.bitv.com/ws/v2`*  


## 簽名認證

### 簽名說明

API 請求在通過 internet 傳輸的過程中極有可能被篡改，為了確保請求未被更改，除公共接口（基礎信息，行情數據）外的私有接口均必須使用您的 API Key 做簽名認證，以校驗參數或參數值在傳輸途中是否發生了更改。  
每一個API Key需要有適當的權限才能訪問相應的接口，每個新創建的API Key都需要分配權限。在使用接口前，請查看每個接口的權限類型，並確認你的API Key有相應的權限。

一個合法的請求由以下幾部分組成：

- 方法請求地址：即訪問服務器地址https://api.bitv.com
- API 訪問Id（AccessKeyId）：您申請的 API Key 中的 Access Key。
- 簽名方法（SignatureMethod）：用戶計算簽名的基於哈希的協議，此處使用 HmacSHA256。
- 簽名版本（SignatureVersion）：簽名協議的版本，此處使用2。
- 時間戳（Timestamp）：您發出請求的時間 (UTC 時間)  。如：2017-05-11T16:22:06。在查詢請求中包含此值有助於防止第三方截取您的請求。
- 必選和可選參數：每個方法都有一組用於定義 API 調用的必需參數和可選參數。可以在每個方法的說明中查看這些參數及其含義。 
  - 對於 GET 請求，每個方法自帶的參數都需要進行簽名運算。
  - 對於 POST 請求，每個方法自帶的參數不進行簽名認證，並且需要放在 body 中。
- 簽名：簽名計算得出的值，用於確保簽名有效和未被篡改。

### 簽名步驟

規範要計算簽名的請求 因為使用 HMAC 進行簽名計算時，使用不同內容計算得到的結果會完全不同。所以在進行簽名計算前，請先對請求進行規範化處理。下面以查詢某訂單詳情請求為例進行說明：

查詢某訂單詳情時完整的請求URL

`https://api.bitv.com/v1/order/orders?`

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`&SignatureMethod=HmacSHA256`

`&SignatureVersion=2`

`&Timestamp=2017-05-11T15:19:30`

`&order-id=1234567890`

**1. 請求方法（GET 或 POST，WebSocket用GET），後面添加換行符 「\n」**

例如：
`GET\n`

**2. 添加小寫的訪問域名，後面添加換行符 「\n」**

例如：
`api.bitv.com\n`

**3. 訪問方法的路徑，後面添加換行符 「\n」**

例如查詢訂單：<BR>
`
/v1/order/orders\n
`

例如WebSocket v2<BR>
`
/ws/v2
`

**4. 對參數進行URL編碼，並且按照ASCII碼順序進行排序**

例如，下面是請求參數的原始順序，且進行URL編碼後


`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`order-id=1234567890`

`SignatureMethod=HmacSHA256`

`SignatureVersion=2`

`Timestamp=2017-05-11T15%3A19%3A30`

<aside class="notice">
使用 UTF-8 編碼，且進行了 URL 編碼，十六進制字符必須大寫，如 「:」 會被編碼為 「%3A」 ，空格被編碼為 「%20」。
</aside>
<aside class="notice">
時間戳（Timestamp）需要以YYYY-MM-DDThh:mm:ss格式添加並且進行 URL 編碼。
</aside>


經過排序之後

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`SignatureMethod=HmacSHA256`

`SignatureVersion=2`

`Timestamp=2017-05-11T15%3A19%3A30`

`order-id=1234567890`

**5. 按照以上順序，將各參數使用字符 「&」 連接**


`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15%3A19%3A30&order-id=1234567890`

**6. 組成最終的要進行簽名計算的字符串如下**

`GET\n`

`api.bitv.com\n`

`/v1/order/orders\n`

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15%3A19%3A30&order-id=1234567890`


**7. 用上一步里生成的 「請求字符串」 和你的密鑰 (Secret Key) 生成一個數字簽名**


1. 將上一步得到的請求字符串和 API 私鑰作為兩個參數，調用HmacSHA256哈希函數來獲得哈希值。
2. 將此哈希值用base-64編碼，得到的值作為此次接口調用的數字簽名。

`4F65x5A2bLyMWVQj3Aqp+B4w+ivaA7n5Oi2SuYtCJ9o=`

**8. 將生成的數字簽名加入到請求里**

對於Rest接口：

1. 把所有必須的認證參數添加到接口調用的路徑參數里
2. 把數字簽名在URL編碼後加入到路徑參數里，參數名為「Signature」。

最終，發送到服務器的 API 請求應該為

`https://api.bitv.com/v1/order/orders?AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&order-id=1234567890&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15%3A19%3A30&Signature=4F65x5A2bLyMWVQj3Aqp%2BB4w%2BivaA7n5Oi2SuYtCJ9o%3D`

對於WebSocket接口：

1. 按照要求的JSON格式，填入參數和簽名。
2. JSON請求中的參數不需要URL編碼

例如：

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

## 子用戶

子用戶可以用來隔離資產與交易，資產可以在母子用戶之間划轉；子用戶只能在子用戶內進行交易，並且子用戶之間資產不能直接划轉，只有母用戶有划轉權限。  

子用戶擁有獨立的登錄賬號密碼和 API Key，均由母用戶在網頁端進行管理。 

每個母用戶可創建200個子用戶，每個子用戶可創建5組Api Key，每個Api Key可對應設置讀取、交易兩種權限。

子用戶的 API Key 也可綁定 IP 地址, 有效期的限制與母用戶的API Key一致。

子用戶可以訪問所有公共接口，包括基本信息和市場行情，子用戶可以訪問的私有接口如下：

| 接口                                                         | 說明                            |
| ------------------------------------------------------------ | ------------------------------- |
| [POST /v1/order/orders/place](#fd6ce2a756)                   | 創建並執行訂單                  |
| [POST /v1/order/orders/{order-id}/submitcancel](#4e53c0fccd) | 撤銷一個訂單                    |
| [POST /v1/order/orders/submitCancelClientOrder](#client-order-id) | 撤銷訂單（基於client order ID） |
| [POST /v1/order/orders/batchcancel](#ad00632ed5)             | 批量撤銷訂單                    |
| [POST /v1/order/orders/batchCancelOpenOrders](#open-orders)  | 撤銷當前委託訂單                |
| [GET /v1/order/orders/{order-id}](#92d59b6aad)               | 查詢一個訂單詳情                |
| [GET /v1/order/orders](#d72a5b49e7)                          | 查詢當前委託、歷史委託          |
| [GET /v1/order/openOrders](#95f2078356)                      | 查詢當前委託訂單                |
| [GET /v1/order/matchresults](#0fa6055598)                    | 查詢成交                        |
| [GET /v1/order/orders/{order-id}/matchresults](#56c6c47284)  | 查詢某個訂單的成交明細          |
| [GET /v1/account/accounts](#bd9157656f)                      | 查詢當前用戶的所有賬戶          |
| [GET /v1/account/accounts/{account-id}/balance](#870c0ab88b) | 查詢指定賬戶的餘額              |
| [GET /v1/account/history](#84f1b5486d)                       | 查詢賬戶流水                    |
| [GET /v2/account/ledger](#2f6797c498)                        | 查詢財務流水                    |
| [POST /v1/account/transfer](#0d3c2e7382)                     | 資產划轉                        |

<aside class="notice">
其他接口子用戶不可訪問，如果嘗試訪問，系統會返回 「error-code 403」。
</aside>


## 業務字典

### 交易對

交易對由基礎幣種和報價幣種組成。以交易對 BTC/USDT 為例，BTC 為基礎幣種，USDT 為報價幣種。  

基礎幣種對應字段為 base-currency 。  

報價幣種對應字段為 quote-currency 。 

### 賬戶

不同業務對應需要不同的賬戶，account-id為不同業務賬戶的唯一標識ID。  

account-id可通過/v1/account/accounts接口獲取，並根據account-type區分具體賬戶。  

賬戶類型包括：   

* spot：現貨賬戶  

### 訂單、成交相關ID說明  

* order-id : 訂單的唯一編號  
* client-order-id : 客戶自定義ID，該ID在下單時傳入，與下單成功後返回的order-id對應，該ID 24小時內有效。  允許的字符包括字母(大小寫敏感)、數字、下划線 (_)和橫線(-)，最長64位
* match-id : 訂單在撮合中的順序編號  
* trade-id : 成交的唯一編號  

### 訂單類型

當前的訂單類型是由買賣方向以及訂單操作類型組成，例如：buy-market，buy為買賣方向，market為操作類型。    

買賣方向：  

* buy : 買  
* sell: 賣   

訂單種類:  

* limit : 限價單，該類型訂單需指定下單價格，下單數量。  
* market : 市價單，該類型訂單僅需指定下單金額或下單數量，不需要指定價格，訂單在進入撮合時，會直接與對手方進行成交，直至金額或數量低於最小成交金額或成交數量為止。  
* limit-maker : 限價掛單，該訂單在進入撮合時，只能作為maker進入市場深度,若訂單會被成交，則撮合會直接拒絕該訂單。  
* ioc : 立即成交或取消（immediately or cancel），該訂單在進入撮合後，若不能直接成交，則會被直接取消（部分成交後，剩餘部分也會被取消）。  
* stop-limit : 止盈止損單，設置高於或低於市場價格的訂單，當訂單到達觸發價格後，才會正式的進入撮合隊列。  

### 訂單狀態

* submitted : 等待成交，該狀態訂單已進入撮合隊列當中。  
* partial-filled : 部分成交，該狀態訂單在撮合隊列當中，訂單的部分數量已經被市場成交，等待剩餘部分成交。  
* filled : 已成交。該狀態訂單不在撮合隊列中，訂單的全部數量已經被市場成交。  
* partial-canceled : 部分成交撤銷。該狀態訂單不在撮合隊列中，此狀態由partial-filled轉化而來，訂單數量有部分被成交，但是被撤銷。  
* canceled : 已撤銷。該狀態訂單不在撮合訂單中，此狀態訂單沒有任何成交數量，且被成功撤銷。  
* canceling : 撤銷中。該狀態訂單正在被撤銷的過程中，因訂單最終需在撮合隊列中剔除才會被真正撤銷，所以此狀態為中間過渡態。  

# 接入說明

## 接口概覽

| 接口分類 | 分類鏈接                     | 概述                                             |
| -------- | ---------------------------- | ------------------------------------------------ |
| 基礎類   | /v1/common/*                 | 基礎類接口，包括幣種、幣種對、時間戳等接口       |
| 行情類   | /market/*                    | 公共行情類接口，包括成交、深度、行情等           |
| 賬戶類   | /v1/account/*  /v1/subuser/* | 賬戶類接口，包括賬戶信息，子用戶等               |
| 訂單類   | /v1/order/*                  | 訂單類接口，包括下單、撤單、訂單查詢、成交查詢等 |

該分類為大類整理，部分接口未遵循此規則，請根據需求查看有關接口文檔。

## 新限頻規則

- 當前，新限頻規則正在逐步上線中，已單獨標注限頻值的接口且該限頻值被標注為NEW的接口適用新限頻規則。

- 新限頻規則採用基於UID的限頻機制，即，同一UID下各API Key同時對某單個節點請求的頻率不能超出單位時間內該節點最大允許訪問次數的限制。

- 用戶可根據Http Header中的"X-HB-RateLimit-Requests-Remain"（限頻剩餘次數）及"X-HB-RateLimit-Requests-Expire"（窗口過期時間）查看當前限頻使用情況，以及所在時間窗口的過期時間，根據該數值動態調整您的請求頻率。

## 限頻規則

除已單獨標注限頻值為NEW的接口外 -<br>

* 每個API Key 在1秒之內限制10次<br>
* 若接口不需要API Key，則每個IP在1秒內限制10次<br>

比如：

* 資產訂單類接口調用根據API Key進行限頻：1秒10次
* 行情類接口調用根據IP進行限頻：1秒10次

## 請求格式

所有的API請求都是restful，目前只有兩種方法：GET和POST

* GET請求：所有的參數都在路徑參數里
* POST請求，所有參數以JSON格式發送在請求主體（body）里

## 返回格式

所有的接口都是JSON格式。其中v1和v2接口的JSON定義略有區別。

**v1接口返回格式**：最上層有四個字段：`status`, `ch`,  `ts` 和 `data`。前三個字段表示請求狀態和屬性，實際的業務數據在`data`字段裡。

以下是一個返回格式的樣例：

```json
{
  "status": "ok",
  "ch": "market.btcusdt.kline.1day",
  "ts": 1499223904680,
  "data": // per API response data in nested JSON object
}
```

| 參數名稱 | 數據類型 | 描述                                                         |
| -------- | -------- | ------------------------------------------------------------ |
| status   | string   | API接口返回狀態                                              |
| ch       | string   | 接口數據對應的數據流。部分接口沒有對應數據流因此不返回此字段 |
| ts       | long     | 接口返回的UTC時間的時間戳，單位毫秒                          |
| data     | object   | 接口返回數據主體                                             |

**v2接口返回格式**：最上層有三個字段：`code`, `message` 和 `data`。前兩個字段表示返回碼和錯誤消息，實際的業務數據在`data`字段裡。

以下是一個返回格式的樣例：

```json
{
  "code": 200,
  "message": "",
  "data": // per API response data in nested JSON object
}
```

| 參數名稱 | 數據類型 | 描述               |
| -------- | -------- | ------------------ |
| code     | int      | API接口返回碼      |
| message  | string   | 錯誤消息（如果有） |
| data     | object   | 接口返回數據主體   |

## 數據類型

本文檔對JSON格式中數據類型的描述做如下約定：

- `string`: 字符串類型，用雙引號（"）引用
- `int`: 32位整數，主要涉及到狀態碼、大小、次數等
- `long`: 64位整數，主要涉及到Id和時間戳
- `float`: 浮點數，主要涉及到金額和價格，建議程序中使用高精度浮點型
- `object`: 對象，包含一個子對象{}
- `array`: 數組，包含多個對象

## 最佳實踐

###安全類

- 強烈建議：在申請API Key時，請綁定您的IP地址，以此來保證您的API Key僅能在您自己的IP上使用。另外，在API Key未綁定IP時，有效期為90天，綁定IP後，則永遠不會過期。
- 強烈建議：不要將API Key暴露給任何人（包括第三方軟件或機構），API Key代表了您的賬戶權限，API Key的暴露可能會對您的信息、資金造成損失，若API Key洩露，請盡快刪除並重新創建。

###公共類

**新限頻規則**

- 當前最新限頻規則正在逐步上線中，已單獨標注限頻值的接口適用新限頻規則。

- 用戶可根據Http Header中「X-HB-RateLimit-Requests-Remain（限頻剩餘次數）」，「X-HB-RateLimit-Requests-Expire（窗口過期時間）」查看當前限頻使用情況，以及所在時間窗口的過期時間，根據該數值動態調整您的請求頻率。

- 同一UID下各API Key同時對某單個節點請求的頻率不能超出單位時間內該節點最大允許訪問次數的限制。

###行情類
**行情類數據的獲取**

- 行情類數據推薦使用WebSocket方式實時接收數據變化的推送，並在程序中進行數據的緩存，WebSocket方式實時性更高，且不受限頻的影響。
- 建議用戶不要在同一條WebSocket連接中訂閱過多的主題和幣種對，否則可能會因為上游數據量過大，導致網絡阻塞，以至於連接斷連。

**最新成交價格的獲取**

- 推薦使用WebSocket的方式訂閱`market.$symbol.trade.detail`主題，該主題為逐筆成交信息推送，該數據中成交的Price即為最新成交價格，且實時性更高。

**盤口深度的獲取**

- 若對盤口數據的要求僅為買一賣一，可使用WebSocket訂閱`market.$symbol.bbo`主題，該主題會在買一賣一變更時進行推送。
- 若需要多檔數據，且對數據的實時性要求不高的情況下，可使用WebSocket訂閱`market.$symbol.depth.$type`主題，該主題推送週期為1秒。
- 若需要多檔數據，且對數據的實時性要求較高的情況下，可使用WebSocket訂閱`market.$symbol.mbp.$levels`主題，並使用該主題發送req請求，構建本地深度，並增量跟新，該主題增量消息推送最快週期為100ms。
- 建議使用Rest（`/market/depth`）、WebSocket全量推送（`market.$symbol.depth.$type`）獲取深度時，根據version字段對數據進行去重（捨棄較小的version）；使用WebSocket增量推送（`market.$symbol.mbp.$levels`）時，根據seqNum字段進行去重（捨棄較小的seqNum）。

**最新成交的獲取**

- 建議訂閱WebSocket成交明細（`market.$symbol.trade.detail`）主題時，可根據tradeId字段對數據進行去重。

###訂單類
**下單接口（/v1/order/orders/place）**

- 建議用戶下單前根據`/v1/common/symbols`接口中返回的幣種對參數數據對下單價格、下單數量等參進行校驗，避免產生無效的下單請求。
- 推薦下單時攜帶`client-order-id`參數，且能夠保證該參數的唯一性（每次發送請求時都不同，且唯一），該參數能夠防止在發起下單請求時由於網絡或其他原因造成接口超時或沒有返回的情況，在此情況下，可根據`client-order-id`對WebSocket中推送過來的數據進行驗證，或使用`/v1/order/orders/getClientOrder`接口查詢該訂單信息。

**搜索歷史訂單（/v1/order/orders）**

- 推薦使用`start-time`、`end-time`參數進行查詢，該參數傳入值為13位時間戳（精確至毫秒），使用該參數查詢時最大查詢窗口為48小時（2天），推薦按照小時進行查詢，您搜索的時間範圍越小，時間戳準確性越高，查詢的效率會更高，可以根據上次查詢的時間戳進行迭代查詢。

**訂單狀態變化的通知**

- 建議使用WebSocket訂閱`orders.$symbol.update`主題，該主題擁有更低的數據延遲以及更準確的消息順序。
- 不建議使用WebSocket訂閱`orders.$symbol`主題，該主題已由`orders.$symbol.update`取代，會在後續停止服務，請盡早更換使用。

###賬戶類
**資產變更**

- 使用WebSocket的方式，同時訂閱`orders.$symbol.update`、`accounts.update#${mode}`主題，`orders.$symbol.update`用於接收訂單的狀態變化（創建、成交、撤銷以及相關成交價格、數量信息），由於該主題在推送數據時，未經過清算，所以時效性更快，可根據`accounts.update#${mode}`主題接收相關資產的變更信息，以此來維護賬戶內的資金情況。
- 不建議WebSocket訂閱`accounts`主題，該主題已由`accounts.update#${mode}`取代，會在後續停止服務，請盡早更換使用。

# 常見問題

## API信息通知

關於API新增、更新、下線等信息會提前發佈公告進行通知，建議您關注和訂閱我們的公告，及時獲取相關信息。  

## 接入、驗簽相關

### Q1：一個用戶可以申請多少個Api Key？

A:  每個母用戶可創建5組Api Key，每個Api Key可對應設置讀取、交易、提幣三種權限。 
每個母用戶還可創建200個子用戶，每個子用戶可創建5組Api Key，每個Api Key可對應設置讀取、交易兩種權限。   

以下是三種權限的說明：  

- 讀取權限：讀取權限用於對數據的查詢接口，例如：訂單查詢、成交查詢等。  
- 交易權限：交易權限用於下單、撤單、划轉類接口。  
- 提幣權限：提幣權限用於創建提幣訂單、取消提幣訂單操作。  

### Q2：為什麼經常出現斷線、超時的情況？

A：請檢查是否屬於以下情況：

1. 客戶端服務器如在中國大陸境內，連接的穩定性很難保證。  

### Q3：為什麼WebSocket總是斷開連接？

A：常見原因有：

1. 未回復Pong，WebSocket連接需在接收到服務端發送的Ping信息後回復Pong，保證連接的穩定。

2. 網絡原因造成客戶端發送了Pong消息，但服務端並未接收到。

3. 網絡原因造成連接斷開。

4. 建議用戶做好WebSocket連接斷連重連機制，在確保心跳（Ping/Pong）消息正確回復後若連接意外斷開，程序能夠自動進行重新連接。

### Q4：為什麼簽名認證總返回失敗？

A：請對比使用Secret Key簽名前的字符串與以下字符串的區別

對比時請注意一下幾點：

1、簽名參數應該按照ASCII碼排序。比如下面是原始的參數：

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`order-id=1234567890`

`SignatureMethod=HmacSHA256` 

`SignatureVersion=2`  

`Timestamp=2017-05-11T15%3A19%3A30` 

排序之後應該為：

`AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx`

`SignatureMethod=HmacSHA256`

`SignatureVersion=2`

`Timestamp=2017-05-11T15%3A19%3A30`

`order-id=1234567890`

2、簽名串需進行URL編碼。比如：

- 冒號 `:`會被編碼為`%3A`，空格會被編碼為 `%20`
- 時間戳需要格式化為 `YYYY-MM-DDThh:mm:ss` ，經過URL編碼之後為 `2017-05-11T15%3A19%3A30`  

3、簽名需進行 base64 編碼

4、Get請求參數需在簽名串中

5、時間為UTC時間轉換為YYYY-MM-DDTHH:mm:ss

6、檢查本機時間與標準時間是否存在偏差（偏差應小於1分鐘）

7、WebSocket發送驗簽認證消息時，消息體不需要URL編碼

8、簽名時所帶Host應與請求接口時Host相同

如果您使用了代理，代理可能會改變請求Host，可以嘗試去掉代理；

您使用的網絡連接庫可能會把端口包含在Host內，可以嘗試在簽名用到的Host中包含端口

9、Api Key 與 Secret Key中是否存在隱藏特殊字符，影響簽名



### Q5：調用接口返回gateway-internal-error錯誤是什麼原因？

A：請檢查是否屬於以下情況：

1. account-id 是否正確，需要由 GET /v1/account/accounts 接口返回的數據。

2. 可能為網絡原因，請稍後進行重試。

3. 發送數據格式是否正確(需要標準JSON格式)。

4. POST請求頭header需要聲明為`Content-Type:application/json` 。

### Q6：調用接口返回 login-required錯誤是什麼原因？

A：請檢查是否屬於以下情況：

1. 應該將AccessKey參數帶入URL中。
2. 應該將Signature參數帶入URL中。
3. account-id 是否正確，是由 `GET /v1/account/accounts` 接口返回的數據。
4. 限頻發生後再次請求時可能引發該錯誤。

### Q7: 調用Rest接口返回HTTP 405錯誤 method-not-allowed是什麼原因？

A：該錯誤表明調用了不存在的Rest接口，請檢查Rest接口路徑是否準確。由於Nginx的設置，請求路徑(Path)是大小寫敏感的，請嚴格按照文檔聲明的大小寫。

## 行情相關

### Q1：當前盤口數據多久更新一次？

A：當前盤口數據數據一秒更新一次，無論是RESTful查詢或是Websocket推送都是一秒一次。若需要實時的買一賣一價格數據，可使用WebSocket訂閱market.$symbol.bbo主題，該主題會實時推送最新的買一賣一價格數據。

### Q2：24小時行情接口(/market/detail)數據接口的成交量會出現負增長嗎？

A：/market/detail接口中的成交量、成交金額為24小時滾動數據（平移窗口大小24小時），有可能會出現後一個窗口內的累計成交量、累計成交額小於前一窗口的情況。

### Q3：如何獲取最新成交價格？

A：推薦使用REST API `GET /market/trade` 接口請求最新成交，或使用WebSocket訂閱market.$symbol.trade.detail主題，根據返回數據中的price獲取。

### Q4：K線是按照什麼時間開始計算的？

A： K線週期以新加坡時間為基準開始計算，例如日K線的起始週期為新加坡時間0時-新加坡時間次日0時。

## 交易相關

### Q1：account-id是什麼？

A： account-id對應用戶不同業務賬戶的ID，可通過/v1/account/accounts接口獲取，並根據account-type區分具體賬戶。

賬戶類型包括：

- spot 現貨賬戶  

### Q2：client-order-id是什麼？

A： client-order-id作為下單請求標識的一個參數，類型為字符串，長度為64。 此id為用戶自己生成，24小時內有效。

### Q3：如何獲取下單數量、金額、小數限制、精度的信息？

A： 可使用 Rest API `GET /v1/common/symbols` 獲取相關幣對信息， 下單時注意最小下單數量和最小下單金額的區別。 

常見返回錯誤如下：  

- order-value-min-error: 下單金額小於最小交易額  
- order-orderprice-precision-error : 限價單價格精度錯誤  
- order-orderamount-precision-error : 下單數量精度錯誤  
- order-limitorder-price-max-error : 限價單價格高於限價閾值  
- order-limitorder-price-min-error : 限價單價格低於限價閾值  
- order-limitorder-amount-max-error : 限價單數量高於限價閾值  
- order-limitorder-amount-min-error : 限價單數量低於限價閾值  

### Q4：WebSocket 訂單更新推送主題orders.\$symbol 和 orders.$symbol.update的區別？

A： 區別如下：

1. order.\$symbol 主題作為老的推送主題，會在一段時間後停止主題的維護和使用， 推薦使用order.$symbol.update主題。

2. 新主題orders.$symbol.update具有嚴格的時序性，保證數據嚴格按照撮合成交順序進行推送，且具有更快的時效性以及更低的時延。

3. 為減少重複數據推送量以及更快的速度，在orders.$symbol.update推送中並未攜帶原始訂單數量，價格信息，若需要此信息，建議可在下單時在本地維護訂單信息，或在接收到推送消息後，使用Rest接口進行查詢。

### Q5： 為什麼收到訂單成功成交的消息後再次進行下單，返回餘額不足？

A：為保證訂單的及時送達以及低延時， 訂單推送的結果是在撮合後直接推送，此時訂單可能並未完成資產的清算。  

建議使用以下方式保證資金可以正確下單：

1. 結合資產推送主題`accounts`同步接收資產變更的消息，確保資金已經完成清算。

2. 收到訂單推送消息時，使用Rest接口調用賬戶餘額，驗證賬戶資金是否足夠。

3. 賬戶中保留相對充足的資金餘額。

### Q6: 撮合結果里的filled-fees和filled-points有什麼區別？

A: 撮合成交中的成交手續費分為普通手續費以及抵扣手續費兩種類型，兩種類型不會同時存在。

1. 普通手續費表示，在成交時未開啓抵扣，使用原幣進行手續費扣除。例如：在BTCUSDT幣種對下購買BTC，filled-fees字段不為空，表示扣除了普通手續費，單位是BTC。

2. 抵扣手續費表示，在成交時，開啓了抵扣，使用抵扣資產作為手續費的抵扣。例如BTCUSDT幣種對下購買BTC，抵扣資產充足時，filled-fees為空，filled-points不為空，表示扣除了抵扣資產作為手續費，扣除單位需參考fee-deduct-currency字段

### Q7: 撮合結果中match-id和trade-id有什麼區別？

A: match-id表示訂單在撮合中的順序號，trade-id表示成交時的序號， 一個match-id可能有多個trade-id（成交時），也可能沒有trade-id(創建訂單、撤銷訂單)

### Q8: 為什麼基於當前盤口買一或者賣一價格進行下單觸發了下單限價錯誤？

A: 當前有基於最新成交價上下一定幅度的限價保護，對流動性不好的幣，基於盤口數據下單可能會觸發限價保護。建議基於ws推送的成交價+盤口數據信息進行下單

## 賬戶充提相關

### Q1：為什麼創建提幣時返回api-not-support-temp-addr錯誤？

A：因安全考慮，API創建提幣時僅支持已在提幣地址列表中的地址，暫不支持使用API添加地址至提幣地址列表中，需在網頁端或APP端添加地址後才可在API中進行提幣操作。

### Q2：為什麼USDT提幣時返回Invaild-Address錯誤？

A：USDT幣種為典型的一幣多鏈幣種， 創建提幣訂單時應填寫chain參數對應地址類型。以下表格展示了鏈和chain參數的對應關係：

| 鏈             | chain 參數 |
| -------------- | ---------- |
| ERC20 （默認） | usdterc20  |
| OMNI           | usdt       |
| TRX            | trc20usdt  |

如果chain參數為空，則默認的鏈為ERC20，或者也可以顯示將參數賦值為`usdterc20`。

如果要提幣到OMNI或者TRX，則chain參數應該填寫usdt或者trc20usdt。chain參數可使用值請參考 `GET /v2/reference/currencies` 接口。


### Q3：創建提幣時fee字段應該怎麼填？

A：請參考 GET /v2/reference/currencies接口返回值，返回信息中withdrawFeeType為提幣手續費類型，根據類型選擇對應字段設置提幣手續費。 

提幣手續費類型包含：  

- transactFeeWithdraw : 單次提幣手續費（僅對固定類型有效，withdrawFeeType=fixed）  
- minTransactFeeWithdraw : 最小單次提幣手續費（僅對區間類型有效，withdrawFeeType=circulated or ratio） 
- maxTransactFeeWithdraw : 最大單次提幣手續費（僅對區間類型和有上限的比例類型有效，withdrawFeeType=circulated or ratio
- transactFeeRateWithdraw :  單次提幣手續費率（僅對比例類型有效，withdrawFeeType=ratio）

### Q4：如何查看我的提幣額度？

A：請參考/v2/account/withdraw/quota接口返回值，返回信息中包含您查詢幣種的單次、當日、當前、總提幣額度以及剩餘額度的信息。 

備注：若您有大額提幣需求，且提幣數額超出相關限額，可聯繫官方客服進行溝通。  

# 基礎信息

## 簡介

基礎信息Rest接口提供了市場狀態、交易對信息、幣種信息、幣鏈信息、服務器時間戳等公共參考信息。

## 獲取當前市場狀態

此節點返回當前最新市場狀態。<br>
狀態枚舉值包括: 1 - 正常（可下單可撤單），2 - 掛起（不可下單不可撤單），3 - 僅撤單（不可下單可撤單）。<br>
掛起原因枚舉值包括: 2 - 緊急維護，3 - 計劃維護。<br>

```shell
curl "https://api.bitv.com/v2/market-status"
```


### HTTP 請求

- GET `/v2/market-status`

### 請求參數

此接口不接受任何參數。

> Responds:

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "marketStatus": 1
    }
}
```

### 返回字段

| 名稱              | 類型    | 是否必需 | 描述                                                         |
| ----------------- | ------- | -------- | ------------------------------------------------------------ |
| code              | integer | TRUE     | 狀態碼                                                       |
| message           | string  | FALSE    | 錯誤描述（如有）                                             |
| data              | object  | TRUE     |                                                              |
| { marketStatus    | integer | TRUE     | 市場狀態（1=normal, 2=halted, 3=cancel-only）                |
| haltStartTime     | long    | FALSE    | 市場暫停開始時間（unix time in millisecond），僅對marketStatus=halted或cancel-only有效 |
| haltEndTime       | long    | FALSE    | 市場暫停預計結束時間（unix time in millisecond），僅對marketStatus=halted或cancel-only有效；如在marketStatus=halted或cancel-only時未返回此字段，意味著市場暫停結束時間暫時無法預計 |
| haltReason        | integer | FALSE    | 市場暫停原因（2=emergency-maintenance, 3=scheduled-maintenance），僅對marketStatus=halted或cancel-only有效 |
| affectedSymbols } | string  | FALSE    | 市場暫停影響的交易對列表，以逗號分隔，如影響所有交易對返回"all"，僅對marketStatus=halted或cancel-only有效 |

## 獲取所有交易對

此接口返回所有支持的交易對。

```shell
curl "https://api.bitv.com/v1/common/symbols"
```


### HTTP 請求

- GET `/v1/common/symbols`

### 請求參數

此接口不接受任何參數。

> Responds:

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
    ......
    ]
}
```

### 返回字段

| 字段名稱                   | 是否必須 | 數據類型 | 描述                                                         |
| -------------------------- | -------- | -------- | ------------------------------------------------------------ |
| base-currency              | true     | string   | 交易對中的基礎幣種                                           |
| quote-currency             | true     | string   | 交易對中的報價幣種                                           |
| price-precision            | true     | integer  | 交易對報價的精度（小數點後位數）                             |
| amount-precision           | true     | integer  | 交易對基礎幣種計數精度（小數點後位數）                       |
| symbol-partition           | true     | string   | 交易區，可能值: [main，innovation]                           |
| symbol                     | true     | string   | 交易對                                                       |
| state                      | true     | string   | 交易對狀態；可能值: [online，offline,suspend] online - 已上線；offline - 交易對已下線，不可交易；suspend -- 交易暫停；pre-online - 即將上線 |
| value-precision            | true     | integer  | 交易對交易金額的精度（小數點後位數）                         |
| min-order-amt              | true     | float    | 交易對限價單最小下單量 ，以基礎幣種為單位（即將廢棄）        |
| max-order-amt              | true     | float    | 交易對限價單最大下單量 ，以基礎幣種為單位（即將廢棄）        |
| limit-order-min-order-amt  | true     | float    | 交易對限價單最小下單量 ，以基礎幣種為單位（NEW）             |
| limit-order-max-order-amt  | true     | float    | 交易對限價單最大下單量 ，以基礎幣種為單位（NEW）             |
| sell-market-min-order-amt  | true     | float    | 交易對市價賣單最小下單量，以基礎幣種為單位（NEW）            |
| sell-market-max-order-amt  | true     | float    | 交易對市價賣單最大下單量，以基礎幣種為單位（NEW）            |
| buy-market-max-order-value | true     | float    | 交易對市價買單最大下單金額，以計價幣種為單位（NEW）          |
| min-order-value            | true     | float    | 交易對限價單和市價買單最小下單金額 ，以計價幣種為單位        |
| max-order-value            | false    | float    | 交易對限價單和市價買單最大下單金額 ，以折算後的USDT為單位（NEW） |
| api-trading                | true     | string   | API交易使能標記（有效值：enabled, disabled）                 |

## 獲取所有幣種

此接口返回所有支持的幣種。


```shell
curl "https://api.bitv.com/v1/common/currencys"
```

### HTTP 請求

- GET `/v1/common/currencys`


### 請求參數

此接口不接受任何參數。


> Response:

```json
  "data": [
    "usdt",
    "eth",
    "etc"
  ]
```

### 返回字段


<aside class="notice">返回的「data」對象是一個字符串數組，每一個字符串代表一個支持的幣種。</aside>

## APIv2 幣鏈參考信息

此節點用於查詢各幣種及其所在區塊鏈的靜態參考信息（公共數據）

### HTTP 請求

- GET `/v2/reference/currencies`

```shell
curl "https://api.bitv.com/v2/reference/currencies?currency=usdt"
```

### 請求參數

| 字段名稱       | 是否必需 | 類型    | 字段描述   | 取值範圍                                                     |
| -------------- | -------- | ------- | ---------- | ------------------------------------------------------------ |
| currency       | false    | string  | 幣種       | btc, ltc, bch, eth, etc ...(取值參考`GET /v1/common/currencys`) |
| authorizedUser | false    | boolean | 已認證用戶 | true or false (如不填，缺省為true)                           |

> Response:

```json
{
    "code":200,
    "data":[
        {
            "chains":[
                {
                    "chain":"trc20usdt",
                    "displayName":"",
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
                    "withdrawQuotaPerDay":"180000.00000000",
                    "withdrawQuotaPerYear":"200000.00000000",
                    "withdrawQuotaTotal":"300000.00000000",
                    "withdrawStatus":"allowed"
                }
            ],
            "currency":"usdt",
            "instStatus":"normal"
        }
        ]
}

```

### 響應數據


| 字段名稱                | 是否必需 | 數據類型 | 字段描述                                                     | 取值範圍               |
| ----------------------- | -------- | -------- | ------------------------------------------------------------ | ---------------------- |
| code                    | true     | int      | 狀態碼                                                       |                        |
| message                 | false    | string   | 錯誤描述（如有）                                             |                        |
| data                    | true     | object   |                                                              |                        |
| { currency              | true     | string   | 幣種                                                         |                        |
| { chains                | true     | object   |                                                              |                        |
| chain                   | true     | string   | 鏈名稱                                                       |                        |
| displayName             | true     | string   | 鏈顯示名稱                                                   |                        |
| baseChain               | false    | string   | 底層鏈名稱                                                   |                        |
| baseChainProtocol       | false    | string   | 底層鏈協議                                                   |                        |
| isDynamic               | false    | boolean  | 是否動態手續費（僅對固定類型有效，withdrawFeeType=fixed）    | true,false             |
| numOfConfirmations      | true     | int      | 安全上賬所需確認次數（達到確認次數後允許提幣）               |                        |
| numOfFastConfirmations  | true     | int      | 快速上賬所需確認次數（達到確認次數後允許交易但不允許提幣）   |                        |
| minDepositAmt           | true     | string   | 單次最小充幣金額                                             |                        |
| depositStatus           | true     | string   | 充幣狀態                                                     | allowed,prohibited     |
| minWithdrawAmt          | true     | string   | 單次最小提幣金額                                             |                        |
| maxWithdrawAmt          | true     | string   | 單次最大提幣金額                                             |                        |
| withdrawQuotaPerDay     | true     | string   | 當日提幣額度（新加坡時區）                                   |                        |
| withdrawQuotaPerYear    | true     | string   | 當年提幣額度                                                 |                        |
| withdrawQuotaTotal      | true     | string   | 總提幣額度                                                   |                        |
| withdrawPrecision       | true     | int      | 提幣精度                                                     |                        |
| withdrawFeeType         | true     | string   | 提幣手續費類型（特定幣種在特定鏈上的提幣手續費類型唯一）     | fixed,circulated,ratio |
| transactFeeWithdraw     | false    | string   | 單次提幣手續費（僅對固定類型有效，withdrawFeeType=fixed）    |                        |
| minTransactFeeWithdraw  | false    | string   | 最小單次提幣手續費（僅對區間類型和有下限的比例類型有效，withdrawFeeType=circulated or ratio） |                        |
| maxTransactFeeWithdraw  | false    | string   | 最大單次提幣手續費（僅對區間類型和有上限的比例類型有效，withdrawFeeType=circulated or ratio） |                        |
| transactFeeRateWithdraw | false    | string   | 單次提幣手續費率（僅對比例類型有效，withdrawFeeType=ratio）  |                        |
| withdrawStatus}         | true     | string   | 提幣狀態                                                     | allowed,prohibited     |
| instStatus }            | true     | string   | 幣種狀態                                                     | normal,delisted        |

### 狀態碼

| 狀態碼 | 錯誤信息                            | 錯誤場景描述 |
| ------ | ----------------------------------- | ------------ |
| 200    | success                             | 請求成功     |
| 500    | error                               | 系統錯誤     |
| 2002   | invalid field value in "field name" | 非法字段取值 |

## 獲取當前系統時間戳

此接口返回當前的系統時間戳，即從 **UTC** 1970年1月1日0時0分0秒0毫秒到現在的總**毫秒**數。

```shell
curl "https://api.bitv.com/v1/common/timestamp"
```

### HTTP 請求

- GET `/v1/common/timestamp`

### 請求參數

此接口不接受任何參數。

> Response:

```json
  "data": 1494900087029
```

# 行情數據

## 簡介

行情數據接口提供了多種K線、深度以及最新成交記錄等行情數據。

以下是行情數據接口返回的錯誤碼、錯誤消息以及說明。

| 錯誤碼            | 錯誤消息                            | 說明                    |
| ----------------- | ----------------------------------- | ----------------------- |
| invalid-parameter | invalid symbol                      | 無效的交易對            |
| invalid-parameter | invalid period                      | 請求K線，period參數錯誤 |
| invalid-parameter | invalid depth                       | 深度depth參數錯誤       |
| invalid-parameter | invalid type                        | 深度type 參數錯誤       |
| invalid-parameter | invalid size                        | size參數錯誤            |
| invalid-parameter | invalid size,valid range: [1, 2000] | size參數錯誤            |
| invalid-parameter | request timeout                     | 請求超時                |


## K 線數據（蠟燭圖）

此接口返回歷史K線數據。

```shell
curl "https://api.bitv.com/market/history/kline?period=1day&size=200&symbol=btcusdt"
```

### HTTP 請求

- GET `/market/history/kline`

### 請求參數

| 參數   | 數據類型 | 是否必須 | 默認值 | 描述                                       | 取值範圍                                                     |
| ------ | -------- | -------- | ------ | ------------------------------------------ | ------------------------------------------------------------ |
| symbol | string   | true     | NA     | 交易對                                     | btcusdt, ethbtc等                                            |
| period | string   | true     | NA     | 返回數據時間粒度，也就是每根蠟燭的時間區間 | 1min, 5min, 15min, 30min, 60min, 4hour, 1day, 1mon, 1week, 1year |
| size   | integer  | false    | 150    | 返回 K 線數據條數                          | [1, 2000]                                                    |

<aside class="notice">當前 REST API 不支持自定義時間區間，如需要歷史固定時間範圍的數據，請參考 Websocket API 中的 K 線接口。</aside>
<aside class="notice">獲取 hb10 淨值時， symbol 請填寫 「hb10」。</aside>
<aside class="notice">K線週期以新加坡時間為基準開始計算，例如日K線的起始週期為新加坡時間0時-新加坡時間次日0時。</aside>

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

### 響應數據

| 字段名稱 | 數據類型 | 描述                                                    |
| -------- | -------- | ------------------------------------------------------- |
| id       | long     | 調整為新加坡時間的時間戳，單位秒，並以此作為此K線柱的id |
| amount   | float    | 以基礎幣種計量的交易量                                  |
| count    | integer  | 交易次數                                                |
| open     | float    | 本階段開盤價                                            |
| close    | float    | 本階段收盤價                                            |
| low      | float    | 本階段最低價                                            |
| high     | float    | 本階段最高價                                            |
| vol      | float    | 以報價幣種計量的交易量                                  |

## 聚合行情（Ticker）

此接口獲取ticker信息同時提供最近24小時的交易聚合信息。

```shell
curl "https://api.bitv.com/market/detail/merged?symbol=ethusdt"
```

### HTTP 請求

- GET `/market/detail/merged`

### 請求參數

| 參數   | 數據類型 | 是否必須 | 默認值 | 描述   | 取值範圍                                               |
| ------ | -------- | -------- | ------ | ------ | ------------------------------------------------------ |
| symbol | string   | true     | NA     | 交易對 | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |

> Response:

```json
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
  "bid":[1884.0000,1.6702]
}
```

### 響應數據

| 字段名稱 | 數據類型 | 描述                                     |
| -------- | -------- | ---------------------------------------- |
| id       | long     | NA                                       |
| amount   | float    | 以基礎幣種計量的交易量（以滾動24小時計） |
| count    | integer  | 交易次數（以滾動24小時計）               |
| open     | float    | 本階段開盤價（以滾動24小時計）           |
| close    | float    | 本階段最新價（以滾動24小時計）           |
| low      | float    | 本階段最低價（以滾動24小時計）           |
| high     | float    | 本階段最高價（以滾動24小時計）           |
| vol      | float    | 以報價幣種計量的交易量（以滾動24小時計） |
| bid      | object   | 當前的最高買價 [price, size]             |
| ask      | object   | 當前的最低賣價 [price, size]             |

## 所有交易對的最新 Tickers

獲得所有交易對的 tickers。

```shell
curl "https://api.bitv.com/market/tickers"
```

<aside class="notice">此接口返回所有交易對的 ticker，因此數據量較大。</aside>

### HTTP 請求

- GET `/market/tickers`

### 請求參數

此接口不接受任何參數。

> Response:

```json
[  
    {  
        "open":0.044297,      // 開盤價
        "close":0.042178,     // 收盤價
        "low":0.040110,       // 最低價
        "high":0.045255,      // 最高價
        "amount":12880.8510,  
        "count":12838,
        "vol":563.0388715740,
        "symbol":"ethbtc",
        "bid":0.007545,
        "bidSize":0.008,
        "ask":0.008088,
        "askSize":0.009
    },
    {  
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
    }
]
```

### 響應數據

核心響應數據為一個對象列，每個對象包含下面的字段

| 字段名稱 | 數據類型 | 描述                                     |
| -------- | -------- | ---------------------------------------- |
| amount   | float    | 以基礎幣種計量的交易量（以滾動24小時計） |
| count    | integer  | 交易筆數（以滾動24小時計）               |
| open     | float    | 開盤價（以新加坡時間自然日計）           |
| close    | float    | 最新價（以新加坡時間自然日計）           |
| low      | float    | 最低價（以新加坡時間自然日計）           |
| high     | float    | 最高價（以新加坡時間自然日計）           |
| vol      | float    | 以報價幣種計量的交易量（以滾動24小時計） |
| symbol   | string   | 交易對，例如btcusdt, ethbtc              |
| bid      | float    | 買一價                                   |
| bidSize  | float    | 買一量                                   |
| ask      | float    | 賣一價                                   |
| askSize  | float    | 賣一量                                   |

## 市場深度數據

此接口返回指定交易對的當前市場深度數據。

```shell
curl "https://api.bitv.com/market/depth?symbol=btcusdt&type=step2"
```

### HTTP 請求

- GET `/market/depth`

### 請求參數

| 參數   | 數據類型 | 必須  | 默認值 | 描述                             | 取值範圍                                               |
| ------ | -------- | ----- | ------ | -------------------------------- | ------------------------------------------------------ |
| symbol | string   | true  | NA     | 交易對                           | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |
| depth  | integer  | false | 20     | 返回深度的數量                   | 5，10，20                                              |
| type   | string   | true  | step0  | 深度的價格聚合度，具體說明見下方 | step0，step1，step2，step3，step4，step5               |

<aside class="notice">當type值為‘step0’時，‘depth’的默認值為150而非20。 </aside>

**參數type的各值說明**

| 取值  | 說明                  |
| ----- | --------------------- |
| step0 | 無聚合                |
| step1 | 聚合度為報價精度*10   |
| step2 | 聚合度為報價精度*100  |
| step3 | 聚合度為報價精度*500  |
| step4 | 聚合度為報價精度*1000 |

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

### 響應數據

<aside class="notice">返回的JSON頂級數據對象名為'tick'而不是通常的'data'。</aside>

| 字段名稱 | 數據類型 | 描述                               |
| -------- | -------- | ---------------------------------- |
| ts       | integer  | 調整為新加坡時間的時間戳，單位毫秒 |
| version  | integer  | 內部字段                           |
| bids     | object   | 當前的所有買單 [price, size]       |
| asks     | object   | 當前的所有賣單 [price, size]       |

## 最近市場成交記錄

此接口返回指定交易對最新的一個交易記錄。

```shell
curl "https://api.bitv.com/market/trade?symbol=ethusdt"
```

### HTTP 請求

- GET `/market/trade`

### 請求參數

| 參數   | 數據類型 | 是否必須 | 默認值 | 描述                                                   |
| ------ | -------- | -------- | ------ | ------------------------------------------------------ |
| symbol | string   | true     | NA     | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |

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

### 響應數據

<aside class="notice">返回的JSON頂級數據對象名為'tick'而不是通常的'data'。</aside>

| 字段名稱  | 數據類型 | 描述                                               |
| --------- | -------- | -------------------------------------------------- |
| id        | integer  | 唯一交易id（將被廢棄）                             |
| trade-id  | integer  | 唯一成交ID（NEW）                                  |
| amount    | float    | 以基礎幣種為單位的交易量                           |
| price     | float    | 以報價幣種為單位的成交價格                         |
| ts        | integer  | 調整為新加坡時間的時間戳，單位毫秒                 |
| direction | string   | 交易方向：「buy」 或 「sell」, 「buy」 即買，「sell」 即賣 |

## 獲得近期交易記錄

此接口返回指定交易對近期的所有交易記錄。

```shell
curl "https://api.bitv.com/market/history/trade?symbol=ethusdt&size=2"
```

### HTTP 請求

- GET `/market/history/trade`

### 請求參數

| 參數   | 數據類型 | 是否必須 | 默認值 | 描述                                                   |
| ------ | -------- | -------- | ------ | ------------------------------------------------------ |
| symbol | string   | true     | NA     | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |
| size   | integer  | false    | 1      | 返回的交易記錄數量，最大值2000                         |

> Response:

```json
[  
   {  
      "id":31618787514,
      "ts":1544390317905,
      "data":[  
         {  
            "amount":9.000000000000000000,
            "ts":1544390317905,
            "trade-id": 102043483472,
            "id":3161878751418918529341,
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

### 響應數據

<aside class="notice">返回的數據對象是一個對象數組，每個數組元素為一個調整為新加坡時間的時間戳（單位毫秒）下的所有交易記錄，這些交易記錄以數組形式呈現。</aside>

| 參數      | 數據類型 | 描述                                               |
| --------- | -------- | -------------------------------------------------- |
| id        | integer  | 唯一交易id（將被廢棄）                             |
| trade-id  | integer  | 唯一成交ID（NEW）                                  |
| amount    | float    | 以基礎幣種為單位的交易量                           |
| price     | float    | 以報價幣種為單位的成交價格                         |
| ts        | integer  | 調整為新加坡時間的時間戳，單位毫秒                 |
| direction | string   | 交易方向：「buy」 或 「sell」, 「buy」 即買，「sell」 即賣 |

## 最近24小時行情數據

此接口返回最近24小時的行情數據匯總。

```shell
curl "https://api.bitv.com/market/detail?symbol=ethusdt"
```

### HTTP 請求

- GET `/market/detail`

### 請求參數

| 參數   | 數據類型 | 是否必須 | 默認值 | 描述                                                   |
| ------ | -------- | -------- | ------ | ------------------------------------------------------ |
| symbol | string   | true     | NA     | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |

> Response:

```json
{  
   "amount":613071.438479561,
   "open":86.21,
   "close":94.35,
   "high":98.7,
   "id":31619471534,
   "count":138909,
   "low":84.63,
   "version":31619471534,
   "vol":5.6617373443873316E7
}
```

### 響應數據

<aside class="notice">返回的JSON頂級數據對象名為'tick'而不是通常的'data'。</aside>

| 字段名稱 | 數據類型 | 描述                                     |
| -------- | -------- | ---------------------------------------- |
| id       | integer  | 響應id                                   |
| amount   | float    | 以基礎幣種計量的交易量（以滾動24小時計） |
| count    | integer  | 交易次數（以滾動24小時計）               |
| open     | float    | 本階段開盤價（以滾動24小時計）           |
| close    | float    | 本階段收盤價（以滾動24小時計）           |
| low      | float    | 本階段最低價（以滾動24小時計）           |
| high     | float    | 本階段最高價（以滾動24小時計）           |
| vol      | float    | 以報價幣種計量的交易量（以滾動24小時計） |
| version  | integer  | 內部數據                                 |

# 賬戶相關

## 簡介

賬戶相關接口提供了賬戶、餘額、歷史等查詢以及資產划轉等功能。

<aside class="notice">訪問賬戶相關的接口需要進行簽名認證。</aside>

以下是賬戶相關接口返回的錯誤碼、錯誤消息以及說明。

| 錯誤碼 | 錯誤消息                                    | 說明                                                |
| ------ | ------------------------------------------- | --------------------------------------------------- |
| 500    | system error                                | 調用內部服務異常                                    |
| 1002   | forbidden                                   | 禁止操作，如用戶入參中accountId與UID不一致          |
| 2002   | "invalid field value in `currency`"         | currency不符合正則規則^[a-z0-9]{2,10}$              |
| 2002   | "invalid field value in `transactTypes`"    | 變動類型transactTypes不是「transfer」                 |
| 2002   | "invalid field value in `sort`"             | 分頁請求參數不是合法的"asc或desc"                   |
| 2002   | "value in `fromId` is not found in record」  | 未找到fromId                                        |
| 2002   | "invalid field value in `accountId`"        | 查詢參數中accountId為空                             |
| 2002   | "value in `startTime` exceeded valid range" | 入參查詢時間大於當前時間，或者距離當前時間超過180天 |
| 2002   | "value in `endTime` exceeded valid range")  | 查詢結束時間小於開始時間，或者查詢時間跨度大於10天  |

## 賬戶信息 

API Key 權限：讀取<br>
限頻值（NEW）：100次/2s

查詢當前用戶的所有賬戶 ID `account-id` 及其相關信息

### HTTP 請求

- GET `/v1/account/accounts`

### 請求參數

無

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

### 響應數據

| 參數名稱 | 是否必須 | 數據類型 | 描述       | 取值範圍                        |
| -------- | -------- | -------- | ---------- | ------------------------------- |
| id       | true     | long     | account-id |                                 |
| state    | true     | string   | 賬戶狀態   | working：正常, lock：賬戶被鎖定 |
| type     | true     | string   | 賬戶類型   | spot：現貨賬戶                  |

## 賬戶餘額

API Key 權限：讀取<br>
限頻值（NEW）：100次/2s

查詢指定賬戶的餘額，支持以下賬戶：

spot：現貨賬戶

### HTTP 請求

- GET `/v1/account/accounts/{account-id}/balance`

### 請求參數

| 參數名稱   | 是否必須 | 類型   | 描述                                                         | 默認值 | 取值範圍 |
| ---------- | -------- | ------ | ------------------------------------------------------------ | ------ | -------- |
| account-id | true     | string | account-id，填在 path 中，取值參考 `GET /v1/account/accounts` |        |          |

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

### 響應數據

| 參數名稱 | 是否必須 | 數據類型 | 描述     | 取值範圍                        |
| -------- | -------- | -------- | -------- | ------------------------------- |
| id       | true     | long     | 賬戶 ID  |                                 |
| state    | true     | string   | 賬戶狀態 | working：正常  lock：賬戶被鎖定 |
| type     | true     | string   | 賬戶類型 | spot：現貨賬戶                  |
| list     | false    | Array    |          |                                 |

list字段說明

| 參數名稱 | 是否必須 | 數據類型 | 描述 | 取值範圍                          |
| -------- | -------- | -------- | ---- | --------------------------------- |
| balance  | true     | string   | 餘額 |                                   |
| currency | true     | string   | 幣種 |                                   |
| type     | true     | string   | 類型 | trade: 交易餘額，frozen: 凍結餘額 |

## 獲取賬戶資產估值

API Key 權限：讀取

限頻值（NEW）：100次/2s

按照BTC或法幣計價單位，獲取指定賬戶的總資產估值。

### HTTP 請求

- GET `/v2/account/asset-valuation`

### 請求參數

| 參數              | 是否必填 | 數據類型 | 描述                                                      | 默認值 | 取值範圍                           |
| ----------------- | -------- | -------- | --------------------------------------------------------- | ------ | ---------------------------------- |
| accountType       | true     | string   | 賬戶類型                                                  | NA     | spot：現貨賬戶                     |
| valuationCurrency | false    | string   | 資產估值法幣，即資產按哪個法幣為單位進行估值。            | BTC    | 可選法幣有：BTC、USD（大小寫敏感） |
| subUid            | false    | long     | 子用戶的 UID，若不填，則返回API key所屬用戶的賬戶資產估值 | NA     |                                    |

> Responds:

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

### 返回字段

|參數|是否必須 | 數據類型  | 說明 |
|-----------|------------|-----------|------------|----------|
| balance  | true | string | 按照某一個法幣為單位的總資產估值 |
| timestamp | true | long | 數據返回時間，為unix time in millisecond  |


## 資產划轉

API Key 權限：交易<br>

該節點為母用戶和子用戶進行資產划轉的通用接口。<br>

僅母用戶支持的功能包括：<br>
1、母用戶幣幣賬戶與子用戶幣幣賬戶間的划轉；<br>
2、不同子用戶幣幣賬戶間划轉；<br>

僅子用戶支持的功能包括：<br>
1、子用戶幣幣賬戶向母用戶下的其他子用戶幣幣賬戶划轉，此權限默認關閉，需母用戶授權。授權接口為 `POST /v2/sub-user/transferability`；<br>
2、子用戶幣幣賬戶向母用戶幣幣賬戶划轉；<br>

其他划轉功能將逐步上線，敬請期待。<br>

### HTTP 請求

- POST `/v1/account/transfer`

### 請求參數

| 參數              | 是否必填 | 數據類型 | 說明                                | 取值範圍                         |
| ----------------- | -------- | -------- | ----------------------------------- | -------------------------------- |
| from-user         | true     | long     | 轉出用戶uid                         | 母用戶uid,子用戶uid              |
| from-account-type | true     | string   | 轉出賬戶類型                        | spot                             |
| from-account      | true     | long     | 轉出賬戶id                          |                                  |
| to-user           | true     | long     | 轉入用戶uid                         | 母用戶uid,子用戶uid              |
| to-account-type   | true     | string   | 轉入賬戶類型                        | spot                             |
| to-account        | true     | long     | 轉入賬戶id                          |                                  |
| currency          | true     | string   | 幣種，即btc, ltc, bch, eth, etc ... | 取值參考GET /v1/common/currencys |
| amount            | true     | string   | 划轉金額                            |                                  |


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

### 響應數據

| 參數            | 是否必須 | 數據類型 | 說明       | 取值範圍        |
| --------------- | -------- | -------- | ---------- | --------------- |
| status          | true     | string   | 狀態       | "ok" or "error" |
| data            | true     | list     |            |                 |
| { transact-id   | true     | int      | 交易流水號 |                 |
| transact-time } | true     | long     | 交易時間   |                 |


## 賬戶流水

API Key 權限：讀取<br>
限頻值（NEW）：5次/2s

該節點基於用戶賬戶ID返回賬戶流水。

### HTTP Request

- GET `/v1/account/history`

### 請求參數

| 參數名稱       | 是否必需 | 數據類型 | 描述                                                         | 缺省值               | 取值範圍                                                     |
| -------------- | -------- | -------- | ------------------------------------------------------------ | -------------------- | ------------------------------------------------------------ |
| account-id     | true     | string   | 賬戶編號,取值參考 `GET /v1/account/accounts`                 |                      |                                                              |
| currency       | false    | string   | 幣種,即btc, ltc, bch, eth, etc ...(取值參考`GET /v1/common/currencys`) |                      |                                                              |
| transact-types | false    | string   | 變動類型，可多選，以逗號分隔                                 | all                  | trade (交易), transact-fee（交易手續費）, fee-deduction（手續費抵扣）, transfer（划轉）, deposit（充幣），withdraw（提幣）, withdraw-fee（提幣手續費）, other-types（其他）,rebate（交易返傭） |
| start-time     | false    | long     | 遠點時間 unix time in millisecond. 以transact-time為key進行檢索. 查詢窗口最大為1小時. 窗口平移範圍為最近30天. | ((end-time) – 1hour) | [((end-time) – 1hour), (end-time)]                           |
| end-time       | false    | long     | 近點時間unix time in millisecond. 以transact-time為key進行檢索. 查詢窗口最大為1小時. 窗口平移範圍為最近30天. | current-time         | [(current-time) – 29days,(current-time)]                     |
| sort           | false    | string   | 檢索方向                                                     | asc                  | asc or desc                                                  |
| size           | false    | int      | 最大條目數量                                                 | 100                  | [1,500]                                                      |
| from-id        | false    | long     | 起始編號（僅在下頁查詢時有效）                               |                      |                                                              |

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

### 響應數據

| 字段名稱      | 數據類型 | 描述                                                 | 取值範圍 |
| ------------- | -------- | ---------------------------------------------------- | -------- |
| status        | string   | 狀態碼                                               |          |
| data          | object   |                                                      |          |
| { account-id  | long     | 賬戶編號                                             |          |
| currency      | string   | 幣種                                                 |          |
| transact-amt  | string   | 變動金額（入賬為正 or 出賬為負）                     |          |
| transact-type | string   | 變動類型                                             |          |
| avail-balance | string   | 可用餘額                                             |          |
| acct-balance  | string   | 賬戶餘額                                             |          |
| transact-time | long     | 交易時間（數據庫記錄時間）                           |          |
| record-id }   | long     | 數據庫記錄編號（全局唯一）                           |          |
| next-id       | long     | 下頁起始編號（僅在查詢結果需要分頁返回時包含此字段） |          |

## 財務流水

API Key 權限：讀取

該節點基於用戶賬戶ID返回財務流水。<br>
一期上線暫時僅支持划轉流水的查詢（「transactType」 = 「transfer」）。<br>
通過「startTime」/「endTime」框定的查詢窗口最大為10天，意即，通過單次查詢可檢索的範圍最大為10天。<br>
該查詢窗口可在最近180天範圍內平移，意即，通過多次平移窗口查詢，最多可檢索到過往180天的記錄。<br>

### HTTP Request

- GET `/v2/account/ledger`

### 請求參數

| 參數名稱      | 數據類型 | 是否必需 | 描述                                                |
| ------------- | -------- | -------- | --------------------------------------------------- |
| accountId     | string   | TRUE     | 賬戶編號                                            |
| currency      | string   | FALSE    | 幣種 （缺省值所有幣種）                             |
| transactTypes | string   | FALSE    | 變動類型，可多填 （缺省值all） 枚舉值： transfer    |
| startTime     | long     | FALSE    | 遠點時間（取值範圍及缺省值見注1）                   |
| endTime       | long     | FALSE    | 近點時間（取值範圍及缺省值見注2）                   |
| sort          | string   | FALSE    | 檢索方向（asc 由遠及近, desc 由近及遠，缺省值desc） |
| limit         | int      | FALSE    | 單頁最大返回條目數量 [1,500] （缺省值100）          |
| fromId        | long     | FALSE    | 起始編號（僅在下頁查詢時有效，見注3）               |

注1：<br>
startTime取值範圍：[(endTime - 10天), endTime], unix time in millisecond<br>
startTime缺省值：(endTime - 10天)

注2：<br>
endTime取值範圍：[(當前時間 - 180天), 當前時間], unix time in millisecond<br>
endTime缺省值：當前時間

> Response:

```json
{
"code": 200,
"message": "success",
"data": [
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

### 響應數據

| 字段名稱     | 數據類型 | 是否必需 | 描述                                                         | 取值範圍                                                     |
| ------------ | -------- | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| code         | integer  | TRUE     | 狀態碼                                                       |                                                              |
| message      | string   | FALSE    | 錯誤描述（如有）                                             |                                                              |
| data         | object   | TRUE     | 按用戶請求參數sort中定義的順序排列                           |                                                              |
| { accountId  | integer  | TRUE     | 賬戶編號                                                     |                                                              |
| currency     | string   | TRUE     | 幣種                                                         |                                                              |
| transactAmt  | number   | TRUE     | 變動金額（入賬為正 or 出賬為負）                             |                                                              |
| transactType | string   | TRUE     | 變動類型                                                     | transfer（划轉）                                             |
| transferType | string   | FALSE    | 划轉類型（僅對transactType=transfer有效）                    | master-transfer-in（轉入到母用戶）, master-transfer-out（從母用戶轉出）, sub-transfer-in（轉入到子用戶）, sub-transfer-out（從子用戶轉出） |
| transactId   | integer  | TRUE     | 交易流水號                                                   |                                                              |
| transactTime | integer  | TRUE     | 交易時間                                                     |                                                              |
| transferer   | integer  | FALSE    | 付款方賬戶ID                                                 |                                                              |
| transferee } | integer  | FALSE    | 收款方賬戶ID                                                 |                                                              |
| nextId       | integer  | FALSE    | 下頁起始編號（僅在查詢結果需要分頁返回時包含此字段，見注3。） |                                                              |

注3：<br>
僅當用戶請求查詢的時間範圍內的數據條目超出單頁限制（由「limit「字段設定）時，服務器才返回」nextId「字段。用戶收到服務器返回的」nextId「後 –<br>
1）	須知曉後續仍有數據未能在本頁返回；<br>
2）	如需繼續查詢下頁數據，應再次請求查詢並將服務器返回的「nextId」作為「fromId「，其它請求參數不變。<br>
3）	作為數據庫記錄ID，「nextId」和「fromId」除了用來翻頁查詢外，無其它業務含義。<br>

# 錢包（充提相關）

## 簡介

充提相關接口提供了充幣地址、提幣地址、提幣額度、充提記錄等查詢，以及提幣、取消提幣等功能。

<aside class="notice">訪問充提相關的接口需要進行簽名認證。</aside>

以下是充提相關接口返回的返回碼、返回消息以及說明。

| 返回碼 | 返回消息                             | 說明         |
| ------ | ------------------------------------ | ------------ |
| 200    | success                              | 請求成功     |
| 500    | error                                | 系統錯誤     |
| 1002   | unauthorized                         | 未授權       |
| 1003   | invalid signature                    | 驗簽失敗     |
| 2002   | invalid field value in "field name"  | 非法字段取值 |
| 2003   | missing mandatory field "field name" | 強制字段缺失 |

## 充幣地址查詢

此節點用於查詢特定幣種（IOTA除外）在其所在區塊鏈中的充幣地址，母子用戶均可用

API Key 權限：讀取<br>
限頻值（NEW）：20次/2s

<aside class="notice"> 充幣地址查詢暫不支持IOTA幣 </aside>

```shell
curl "https://api.bitv.com/v2/account/deposit/address?currency=btc"
```

### HTTP 請求

- GET ` /v2/account/deposit/address`

### 請求參數

| 字段名稱 | 是否必需 | 類型   | 字段描述 | 取值範圍                                                     |
| -------- | -------- | ------ | -------- | ------------------------------------------------------------ |
| currency | true     | string | 幣種     | btc, ltc, bch, eth, etc ...(取值參考`GET /v1/common/currencys`) |

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

### 響應數據


| 字段名稱   | 是否必需 | 數據類型 | 字段描述         | 取值範圍 |
| ---------- | -------- | -------- | ---------------- | -------- |
| code       | true     | int      | 狀態碼           |          |
| message    | false    | string   | 錯誤描述（如有） |          |
| data       | true     | object   |                  |          |
| {currency  | true     | string   | 幣種             |          |
| address    | true     | string   | 充幣地址         |          |
| addressTag | true     | string   | 充幣地址標籤     |          |
| chain }    | true     | string   | 鏈名稱           |          |

### 狀態碼

| 狀態碼 | 錯誤信息                             | 錯誤場景描述 |
| ------ | ------------------------------------ | ------------ |
| 200    | success                              | 請求成功     |
| 500    | error                                | 系統錯誤     |
| 1002   | unauthorized                         | 未授權       |
| 1003   | invalid signature                    | 驗簽失敗     |
| 2002   | invalid field value in "field name"  | 非法字段取值 |
| 2003   | missing mandatory field "field name" | 強制字段缺失 |

## 提幣額度查詢

此節點用於查詢各幣種提幣額度，限母用戶可用

API Key 權限：讀取<br>
限頻值（NEW）：20次/2s

```shell
curl "https://api.bitv.com/v2/account/withdraw/quota?currency=btc"
```

### HTTP 請求

- GET ` /v2/account/withdraw/quota`

### 請求參數

| 字段名稱 | 是否必需 | 類型   | 字段描述 | 取值範圍                                                     |
| -------- | -------- | ------ | -------- | ------------------------------------------------------------ |
| currency | true     | string | 幣種     | btc, ltc, bch, eth, etc ...(取值參考`GET /v1/common/currencys`) |

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

### 響應數據

| 字段名稱                   | 是否必需 | 數據類型 | 字段描述         | 取值範圍 |
| -------------------------- | -------- | -------- | ---------------- | -------- |
| code                       | true     | int      | 狀態碼           |          |
| message                    | false    | string   | 錯誤描述（如有） |          |
| data                       | true     | object   |                  |          |
| currency                   | true     | string   | 幣種             |          |
| chains                     | true     | object   |                  |          |
| { chain                    | true     | string   | 鏈名稱           |          |
| maxWithdrawAmt             | true     | string   | 單次最大提幣金額 |          |
| withdrawQuotaPerDay        | true     | string   | 當日提幣額度     |          |
| remainWithdrawQuotaPerDay  | true     | string   | 當日提幣剩餘額度 |          |
| withdrawQuotaPerYear       | true     | string   | 當年提幣額度     |          |
| remainWithdrawQuotaPerYear | true     | string   | 當年提幣剩餘額度 |          |
| withdrawQuotaTotal         | true     | string   | 總提幣額度       |          |
| remainWithdrawQuotaTotal } | true     | string   | 總提幣剩餘額度   |          |

### 狀態碼

| 狀態碼 | 錯誤信息                            | 錯誤場景描述 |
| ------ | ----------------------------------- | ------------ |
| 200    | success                             | 請求成功     |
| 500    | error                               | 系統錯誤     |
| 1002   | unauthorized                        | 未授權       |
| 1003   | invalid signature                   | 驗簽失敗     |
| 2002   | invalid field value in "field name" | 非法字段取值 |

## 提幣地址查詢

API Key 權限：讀取<br>

該節點用於查詢API key可用的提幣地址，限母用戶可用。<br>

### HTTP 請求

- GET `/v2/account/withdraw/address`

### 請求參數

| 參數名稱 | 是否必須 | 類型   | 描述                                                   | 默認值                         | 取值範圍                                                     |
| -------- | -------- | ------ | ------------------------------------------------------ | ------------------------------ | ------------------------------------------------------------ |
| currency | true     | string | 幣種                                                   |                                | btc, ltc, bch, eth, etc ...(取值參考`GET /v1/common/currencys`) |
| chain    | false    | string | 鏈名稱                                                 | 如不填，返回所有鏈的提幣地址   |                                                              |
| note     | false    | string | 地址備注                                               | 如不填，返回所有備注的提幣地址 |                                                              |
| limit    | false    | int    | 單頁最大返回條目數量                                   | 100                            | [1,500]                                                      |
| fromId   | false    | long   | 起始編號（提幣地址ID，僅在下頁查詢時有效，詳細見備注） | NA                             |                                                              |

> Response:

```json
{
    "code": 200,
    "data": [
        {
            "currency": "usdt",
            "chain": "usdt",
            "note": "幣安",
            "addressTag": "",
            "address": "15PrEcqTJRn4haLeby3gJJebtyf4KgWmSd"
        }
    ]
}
```

### 響應數據

| 參數名稱   | 是否必須 | 數據類型 | 描述                                                         | 取值範圍 |
| ---------- | -------- | -------- | ------------------------------------------------------------ | -------- |
| code       | true     | int      | 狀態碼                                                       |          |
| message    | false    | string   | 錯誤描述（如有）                                             |          |
| data       | true     | object   |                                                              |          |
| { currency | true     | string   | 幣種                                                         |          |
| chain      | true     | string   | 鏈名稱                                                       |          |
| note       | true     | string   | 地址備注                                                     |          |
| addressTag | false    | string   | 地址標籤，如有                                               |          |
| address }  | true     | string   | 地址                                                         |          |
| nextId     | false    | long     | 下頁起始編號（提幣地址ID，僅在查詢結果需要分頁返回時，包含此字段，詳細見備注） |          |

備注：<br>
僅當用戶請求查詢的數據條目超出單頁限制（由「limit「字段設定）時，服務器才返回」nextId「字段。用戶收到服務器返回的」nextId「後 –<br>
1）須知曉後續仍有數據未能在本頁返回；<br>
2）如需繼續查詢下頁數據，應再次請求查詢並將服務器返回的「nextId」作為「fromId「，其它請求參數不變。<br>
3）作為數據庫記錄ID，「nextId」和「fromId」除了用來翻頁查詢外，無其它業務含義。<br>


## 虛擬幣提幣

此節點用於將現貨賬戶的數字幣提取到區塊鏈地址（已存在於提幣地址列表）而不需要多重（短信、郵件）驗證，限母用戶可用

API Key 權限：提幣<br>
限頻值（NEW）：20次/2s

<aside class="notice">如果用戶在個人設置 </a> 里設置了優先使用快速提幣，通過API發起的提幣也會優先選擇快速提幣通道。快速提幣是指當提幣目標地址是平台內部用戶地址時，提幣將通過平台內部快速通道，不通過區塊鏈。</aside>
<aside class="notice">API提幣僅支持用戶提幣地址列表</a> 中的地址。IOTA一次性提幣地址無法被設置為常用地址，因此不支持通過API方式提幣IOTA。 </aside>

### HTTP 請求

- POST ` /v1/dw/withdraw/api/create`

> Request:

```json
{
  "address": "0xde709f2102306220921060314715629080e2fb77",
  "amount": "0.05",
  "currency": "eth",
  "fee": "0.01"
}
```

### 請求參數

| 參數名稱 | 是否必須 | 類型   | 描述                                                         | 取值範圍                                                     |
| -------- | -------- | ------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| address  | true     | string | 提幣地址                                                     | 僅支持在官網上相應幣種地址列表中的地址                       |
| amount   | true     | string | 提幣數量                                                     |                                                              |
| currency | true     | string | 資產類型                                                     | btc, ltc, bch, eth, etc ...(取值參考`GET /v1/common/currencys`) |
| fee      | true     | string | 轉賬手續費                                                   |                                                              |
| chain    | false    | string | 取值參考`GET /v2/reference/currencies`,例如提USDT至OMNI時須設置此參數為"usdt"，提USDT至TRX時須設置此參數為"trc20usdt"，其他幣種提幣無須設置此參數 |                                                              |
| addr-tag | false    | string | 虛擬幣共享地址tag，適用於xrp，xem，bts，steem，eos，xmr      | 格式, "123"類的整數字符串                                    |

> Response:

```json
{
  "data": 700
}
```

### 響應數據


| 參數名稱 | 是否必須 | 數據類型 | 描述    | 取值範圍 |
| -------- | -------- | -------- | ------- | -------- |
| data     | false    | long     | 提幣 ID |          |


## 取消提幣

此節點用於取消已提交的提幣請求，限母用戶可用

API Key 權限：提幣<br>
限頻值（NEW）：20次/2s

### HTTP 請求

- POST ` /v1/dw/withdraw-virtual/{withdraw-id}/cancel`

### 請求參數

| 參數名稱    | 是否必須 | 類型 | 描述                  | 默認值 | 取值範圍 |
| ----------- | -------- | ---- | --------------------- | ------ | -------- |
| withdraw-id | true     | long | 提幣 ID，填在 path 中 |        |          |


> Response:

```json
{
  "data": 700
}
```

### 響應數據


| 參數名稱 | 是否必須 | 數據類型 | 描述    | 取值範圍 |
| -------- | -------- | -------- | ------- | -------- |
| data     | false    | long     | 提幣 ID |          |

## 充提記錄

此節點用於查詢充提記錄，母子用戶均可用

API Key 權限：讀取<br>
限頻值（NEW）：20次/2s

### HTTP 請求

- GET `/v1/query/deposit-withdraw`

### 請求參數

| 參數名稱 | 是否必須 | 類型   | 描述             | 默認值                                                       | 取值範圍                                                     |
| -------- | -------- | ------ | ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| currency | false    | string | 幣種             |                                                              | btc, ltc, bch, eth, etc ...(取值參考`GET /v1/common/currencys`) |
| type     | true     | string | 充值或提幣       |                                                              | deposit 或 withdraw,子用戶僅可用deposit                      |
| from     | false    | string | 查詢起始 ID      | 缺省時，默認值direct相關。當direct為‘prev’時，from 為1 ，從舊到新升序返回；當direct為’next‘時，from為最新的一條記錄的ID，從新到舊降序返回 |                                                              |
| size     | false    | string | 查詢記錄大小     | 100                                                          | 1-500                                                        |
| direct   | false    | string | 返回記錄排序方向 | 缺省時，默認為「prev」 （升序）                                | 「prev」 （升序）or 「next」 （降序）                            |

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

### 響應數據

| 參數名稱    | 是否必須 | 數據類型 | 描述                                                         | 取值範圍                                 |
| ----------- | -------- | -------- | ------------------------------------------------------------ | ---------------------------------------- |
| id          | true     | long     | 充幣訂單id                                                   |                                          |
| type        | true     | string   | 類型                                                         | 'deposit', 'withdraw', 子用戶僅有deposit |
| currency    | true     | string   | 幣種                                                         |                                          |
| tx-hash     | true     | string   | 交易哈希                                                     |                                          |
| chain       | true     | string   | 鏈名稱                                                       |                                          |
| amount      | true     | float    | 個數                                                         |                                          |
| address     | true     | string   | 目的地址                                                     |                                          |
| address-tag | true     | string   | 地址標籤                                                     |                                          |
| fee         | true     | float    | 手續費                                                       |                                          |
| state       | true     | string   | 狀態                                                         | 狀態參見下表                             |
| error-code  | false    | string   | 提幣失敗錯誤碼，僅type為」withdraw「，且state為」reject「、」wallet-reject「和」failed「時有。 |                                          |
| error-msg   | false    | string   | 提幣失敗錯誤描述，僅type為」withdraw「，且state為」reject「、」wallet-reject「和」failed「時有。 |                                          |
| created-at  | true     | long     | 發起時間                                                     |                                          |
| updated-at  | true     | long     | 最後更新時間                                                 |                                          |


- 虛擬幣充值狀態定義：

| 狀態       | 描述     |
| ---------- | -------- |
| unknown    | 狀態未知 |
| confirming | 確認中   |
| confirmed  | 已確認   |
| safe       | 已完成   |
| orphan     | 待確認   |

- 虛擬幣提幣狀態定義：

| 狀態            | 描述         |
| --------------- | ------------ |
| verifying       | 待驗證       |
| failed          | 驗證失敗     |
| submitted       | 已提交       |
| reexamine       | 審核中       |
| canceled        | 已撤銷       |
| pass            | 審批通過     |
| reject          | 審批拒絕     |
| pre-transfer    | 處理中       |
| wallet-transfer | 已匯出       |
| wallet-reject   | 錢包拒絕     |
| confirmed       | 區塊已確認   |
| confirm-error   | 區塊確認錯誤 |
| repealed        | 已撤銷       |


# 子用戶管理

## 簡介

子用戶管理接口了子用戶的創建、查詢、權限設置、轉賬，子用戶API Key的創建、修改、查詢、刪除，子用戶充提地址、餘額的查詢等功能。

<aside class="notice">訪問子用戶管理的相關接口需要進行簽名認證。</aside>

以下是子用戶相關接口返回的返回碼、返回消息以及說明。

| 錯誤碼 | 返回消息                                                  | 說明                               |
| ------ | --------------------------------------------------------- | ---------------------------------- |
| 1002   | "forbidden"                                               | 禁止操作，如該賬戶不允許創建子用戶 |
| 1003   | "unauthorized」                                            | 未認證                             |
| 2002   | invalid field value                                       | 參數錯誤                           |
| 2014   | number of sub account in the request exceeded valid range | 子賬戶數量達到限制                 |
| 2014   | number of api key in the request exceeded valid range     | API Key數量超過限制                |
| 2016   | invalid request while value specified in sub user states  | 凍結/解凍失敗                      |


## 子用戶創建

此接口用於母用戶進行子用戶創建，單次最多50個

API Key 權限：交易

### HTTP 請求

- POST `/v2/sub-user/creation`

> Request:

```json
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

### 請求參數

| 參數名稱    | 是否必須 | 類型   | 描述                                           | 默認值 | 取值範圍                                                     |
| ----------- | -------- | ------ | ---------------------------------------------- | ------ | ------------------------------------------------------------ |
| userList    | true     | object |                                                |        |                                                              |
| [{ userName | true     | string | 子用戶名，子用戶身份的重要標識，要求平台內唯一 | NA     | 6至20位字母和數字的組合，可為純字母；若字母和數字的組合，需以字母開頭；字母不區分大小寫； |
| note }]     | false    | string | 子用戶備注，無唯一性要求                       | NA     | 最多20位字符，字符類型不限                                   |

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

### 響應數據

| 參數名稱      | 是否必須 | 數據類型 | 描述                                         | 取值範圍 |
| ------------- | -------- | -------- | -------------------------------------------- | -------- |
| code          | true     | int      | 狀態碼                                       |          |
| message       | false    | string   | 錯誤描述（如有）                             |          |
| data          | true     | object   |                                              |          |
| [{ userName   | true     | string   | 子用戶名                                     |          |
| note          | false    | string   | 子用戶備注（僅對有備注的子用戶有效）         |          |
| uid           | false    | long     | 子用戶UID（僅對創建成功的子用戶有效）        |          |
| errCode       | false    | string   | 創建失敗錯誤碼（僅對創建失敗的子用戶有效）   |          |
| errMessage }] | false    | string   | 創建失敗錯誤原因（僅對創建失敗的子用戶有效） |          |

## 獲取子用戶列表

母用戶通過此接口可獲取所有子用戶的UID列表及各用戶狀態

API Key 權限：讀取

### HTTP 請求

- GET `/v2/sub-user/user-list`

### 請求參數

| 參數名稱 | 是否必須 | 類型 | 描述                             | 默認值 | 取值範圍 |
| -------- | -------- | ---- | -------------------------------- | ------ | -------- |
| fromId   | FALSE    | long | 查詢起始編號（僅對翻頁查詢有效） |        |          |

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

### 響應數據

| 參數名稱    | 是否必須 | 數據類型 | 描述                                       | 取值範圍     |
| ----------- | -------- | -------- | ------------------------------------------ | ------------ |
| code        | TRUE     | int      | 狀態碼                                     |              |
| message     | FALSE    | string   | 錯誤描述（如有）                           |              |
| data        | TRUE     | object   |                                            |              |
| { uid       | TRUE     | long     | 子用戶UID                                  |              |
| userState } | TRUE     | string   | 子用戶狀態                                 | lock, normal |
| nextId      | FALSE    | long     | 下頁查詢起始編號（僅在存在下頁數據時返回） |              |

##凍結/解凍子用戶

API Key 權限：交易<br>
限頻值（NEW）：20次/2s

此接口用於母用戶對其下一個子用戶進行凍結和解凍操作

###HTTP 請求

- POST `/v2/sub-user/management`

### 請求參數

| 參數   | 是否必填 | 數據類型 | 長度 | 說明        | 取值範圍                 |
| ------ | -------- | -------- | ---- | ----------- | ------------------------ |
| subUid | true     | long     | -    | 子用戶的UID | -                        |
| action | true     | string   | -    | 操作類型    | lock(凍結)，unlock(解凍) |

> Response:

```json
{
  "code": 200,
	"data": {
     "subUid": 12902150,
     "userState":"lock"}
}
```

### 響應數據

| 參數      | 是否必填 | 數據類型 | 長度 | 說明       | 取值範圍                   |
| --------- | -------- | -------- | ---- | ---------- | -------------------------- |
| subUid    | true     | long     | -    | 子用戶UID  | -                          |
| userState | true     | string   | -    | 子用戶狀態 | lock(已凍結)，normal(正常) |


## 獲取特定子用戶的用戶狀態

母用戶通過此接口可獲取特定子用戶的用戶狀態

API Key 權限：讀取

### HTTP 請求

- GET `/v2/sub-user/user-state`

### 請求參數

| 參數名稱 | 是否必須 | 類型 | 描述      | 默認值 | 取值範圍 |
| -------- | -------- | ---- | --------- | ------ | -------- |
| subUid   | TRUE     | long | 子用戶UID |        |          |

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

### 響應數據

| 參數名稱    | 是否必須 | 數據類型 | 描述             | 取值範圍     |
| ----------- | -------- | -------- | ---------------- | ------------ |
| code        | TRUE     | int      | 狀態碼           |              |
| message     | FALSE    | string   | 錯誤描述（如有） |              |
| data        | TRUE     | object   |                  |              |
| { uid       | TRUE     | long     | 子用戶UID        |              |
| userState } | TRUE     | string   | 子用戶狀態       | lock, normal |

##設置子用戶交易權限

API Key 權限：交易

此接口用於母用戶批量設置子用戶的交易權限。
子用戶的現貨交易權限默認開通無須設置。

###HTTP 請求

- POST `/v2/sub-user/tradable-market`

### 請求參數

| 參數        | 是否必填 | 數據類型 | 長度 | 說明                                          | 取值範圍                     |
| ----------- | -------- | -------- | ---- | --------------------------------------------- | ---------------------------- |
| subUids     | true     | string   | -    | 子用戶UID列表（支持多填，最多50個，逗號分隔） | -                            |
| accountType | true     | string   | -    | 賬戶類型                                      | isolated-margin,cross-margin |
| activation  | true     | string   | -    | 賬戶激活狀態                                  | activated,deactivated        |

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

### 響應數據

| 參數        | 是否必填 | 數據類型 | 長度 | 說明                                                       | 取值範圍                     |
| ----------- | -------- | -------- | ---- | ---------------------------------------------------------- | ---------------------------- |
| code        | true     | int      | -    | 狀態碼                                                     |                              |
| message     | false    | string   | -    | 錯誤描述（如有）                                           |                              |
| data        | true     | object   |      |                                                            |                              |
| {subUid     | true     | string   | -    | 子用戶UID                                                  | -                            |
| accountType | true     | string   | -    | 賬戶類型                                                   | isolated-margin,cross-margin |
| activation  | true     | string   | -    | 賬戶激活狀態                                               | activated,deactivated        |
| errCode     | false    | int      | -    | 請求被拒錯誤碼（僅在設置該subUid市場准入權限錯誤時返回）   |                              |
| errMessage} | false    | string   | -    | 請求被拒錯誤消息（僅在設置該subUid市場准入權限錯誤時返回） |                              |

## 設置子用戶資產轉出權限

API Key 權限：交易

此接口用於母用戶批量設置子用戶的資產轉出權限。
子用戶的資金轉出權限包括：

-	由子用戶現貨（spot）賬戶轉出至同一母用戶下另一子用戶的現貨（spot）賬戶；
-	由子用戶現貨（spot）賬戶轉出至母用戶現貨（spot）賬戶（無須設置，默認開通）。

###HTTP 請求

- POST `/v2/sub-user/transferability`

### 請求參數

| 參數          | 是否必填 | 數據類型 | 長度 | 說明                                          | 取值範圍   |
| ------------- | -------- | -------- | ---- | --------------------------------------------- | ---------- |
| subUids       | true     | string   | -    | 子用戶UID列表（支持多填，最多50個，逗號分隔） | -          |
| accountType   | false    | string   | -    | 賬戶類型（如不填，缺省值spot）                | spot       |
| transferrable | true     | bool     | -    | 可划轉權限                                    | true,false |

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

### 響應數據

| 參數          | 是否必填 | 數據類型 | 長度 | 說明                                                       | 取值範圍   |
| ------------- | -------- | -------- | ---- | ---------------------------------------------------------- | ---------- |
| code          | true     | int      | -    | 狀態碼                                                     |            |
| message       | false    | string   | -    | 錯誤描述（如有）                                           |            |
| data          | true     | object   |      |                                                            |            |
| {subUid       | true     | long     | -    | 子用戶UID                                                  | -          |
| accountType   | true     | string   | -    | 賬戶類型                                                   | spot       |
| transferrable | true     | bool     | -    | 可划轉權限                                                 | true,false |
| errCode       | false    | int      | -    | 請求被拒錯誤碼（僅在設置該subUid市場准入權限錯誤時返回）   |            |
| errMessage}   | false    | string   | -    | 請求被拒錯誤消息（僅在設置該subUid市場准入權限錯誤時返回） |            |

## 獲取特定子用戶的賬戶列表

母用戶通過此接口可獲取特定子用戶的Account ID列表及各賬戶狀態

API Key 權限：讀取

### HTTP 請求

- GET `/v2/sub-user/account-list`

### 請求參數

| 參數名稱 | 是否必須 | 類型 | 描述      | 默認值 | 取值範圍 |
| -------- | -------- | ---- | --------- | ------ | -------- |
| subUid   | TRUE     | long | 子用戶UID |        |          |

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

### 響應數據

| 參數名稱          | 是否必須 | 數據類型 | 描述                                              | 取值範圍               |
| ----------------- | -------- | -------- | ------------------------------------------------- | ---------------------- |
| code              | TRUE     | int      | 狀態碼                                            |                        |
| message           | FALSE    | string   | 錯誤描述（如有）                                  |                        |
| data              | TRUE     | object   |                                                   |                        |
| { uid             | TRUE     | long     | 子用戶UID                                         |                        |
| list              | TRUE     | object   |                                                   |                        |
| { accountType     | TRUE     | string   | 賬戶類型                                          | spot, futures,swap     |
| activation        | TRUE     | string   | 賬戶激活狀態                                      | activated, deactivated |
| transferrable     | FALSE    | bool     | 可划轉權限（僅對accountType=spot有效）            | true, false            |
| accountIds        | FALSE    | object   |                                                   |                        |
| { accountId       | TRUE     | string   | 賬戶ID                                            |                        |
| subType           | FALSE    | string   | 賬戶子類型（僅對accountType=isolated-margin有效） |                        |
| accountStatus }}} | TRUE     | string   | 賬戶狀態                                          | normal, locked         |

## 子用戶API key創建

此接口用於母用戶創建子用戶的API key

API Key 權限：交易

### HTTP 請求

- POST `/v2/sub-user/api-key-generation`

### 請求參數

| 參數名稱    | 是否必須 | 類型   | 描述                                                 | 默認值 | 取值範圍                                                     |
| ----------- | -------- | ------ | ---------------------------------------------------- | ------ | ------------------------------------------------------------ |
| otpToken    | true     | string | 母用戶的谷歌驗證碼，母用戶須在官網頁面啓用GA二次驗證 | NA     | 6個字符，純數字                                              |
| subUid      | true     | long   | 子用戶UID                                            | NA     |                                                              |
| note        | ture     | string | API key備注                                          | NA     | 最多255位字符，字符類型不限                                  |
| permission  | true     | string | API key權限                                          | NA     | 取值範圍：readOnly、trade，其中readOnly必傳，trade選傳，兩個間用半角逗號分隔。 |
| ipAddresses | false    | string | API key綁定的IPv4/IPv6主機地址或IPv4網絡地址         | NA     | 最多綁定20個，多個IP地址用半角逗號分隔，如：192.168.1.1,202.106.96.0/24。如果未綁定任何IP地址，API key有效期僅為90天。 |

> Response:

```json
{
    "code": 200,
    "data": {
        "accessKey": "2b55df29-vf25treb80-1535713d-8aea2",
        "secretKey": "c405c550-6fa0583b-fb4bc38e-d317e",
        "note": "62924133",
        "permission": "trade,readOnly",
        "ipAddresses": "1.1.1.1,1.1.1.2"
    }
}
```

### 響應數據

| 參數名稱      | 是否必須 | 數據類型 | 描述                | 取值範圍 |
| ------------- | -------- | -------- | ------------------- | -------- |
| code          | true     | int      | 狀態碼              |          |
| message       | false    | string   | 錯誤描述（如有）    |          |
| data          | true     | object   |                     |          |
| { note        | true     | string   | API key備注         |          |
| accessKey     | true     | string   | access key          |          |
| secretKey     | true     | string   | secret key          |          |
| permission    | true     | string   | API key權限         |          |
| ipAddresses } | false    | string   | API key綁定的IP地址 |          |

## 母子用戶API key信息查詢

此接口用於母用戶查詢自身的API key信息，以及母用戶查詢子用戶的API key信息

API Key 權限：讀取

### HTTP 請求

- GET `/v2/user/api-key`

### 請求參數

| 參數名稱  | 是否必須 | 類型   | 描述                                                        | 默認值 | 取值範圍 |
| --------- | -------- | ------ | ----------------------------------------------------------- | ------ | -------- |
| uid       | true     | long   | 母用戶UID，子用戶UID                                        | NA     |          |
| accessKey | false    | string | API key的access key，若缺省，則返回UID對應用戶的所有API key | NA     |          |

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
            "permission": "readOnly,trade",
            "ipAddresses": "1.1.1.1,1.1.1.2",
            "validDays": -1,
            "createTime": 1591348751000,
            "updateTime": 1591348751000
        }
    ]
}
```

### 響應數據

| 參數名稱      | 是否必須 | 數據類型 | 描述                    | 取值範圍                      |
| ------------- | -------- | -------- | ----------------------- | ----------------------------- |
| code          | true     | int      | 狀態碼                  |                               |
| message       | false    | string   | 錯誤描述（如有）        |                               |
| data          | true     | object   |                         |                               |
| [{ accessKey  | true     | string   | access key              |                               |
| note          | true     | string   | API key備注             |                               |
| permission    | true     | string   | API key權限             |                               |
| ipAddresses   | false    | string   | API key綁定的IP地址     |                               |
| validDays     | true     | int      | API key剩餘有效天數     | 若為-1，則表示永久有效        |
| status        | true     | string   | API key當前狀態         | normal(正常)，expired(已過期) |
| createTime    | true     | long     | API key創建時間         |                               |
| updateTime }] | true     | long     | API key最近一次修改時間 |                               |

## 修改子用戶API key

此接口用於母用戶修改子用戶的API key

API Key 權限：交易

### HTTP 請求

- POST `/v2/sub-user/api-key-modification`

### 請求參數

| 參數名稱    | 是否必須 | 類型   | 描述                      | 默認值 | 取值範圍                                                     |
| ----------- | -------- | ------ | ------------------------- | ------ | ------------------------------------------------------------ |
| subUid      | true     | long   | 子用戶的uid               | NA     |                                                              |
| accessKey   | true     | string | 子用戶API key的access key | NA     |                                                              |
| note        | false    | string | API key備注               | NA     | 最多255位字符                                                |
| permission  | false    | string | API key權限               | NA     | 取值範圍：readOnly、trade，其中readOnly必傳，trade選傳，兩個間用半角逗號分隔。 |
| ipAddresses | false    | string | API key綁定的IP地址       | NA     | IPv4/IPv6主機地址或IPv4網絡地址，最多綁定20個，多個IP地址用半角逗號分隔，如：192.168.1.1,202.106.96.0/24。如果未綁定任何IP地址，API key有效期僅為90天。 |

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

### 響應數據

| 參數名稱      | 是否必須 | 數據類型 | 描述                | 取值範圍 |
| ------------- | -------- | -------- | ------------------- | -------- |
| code          | true     | int      | 狀態碼              |          |
| message       | false    | string   | 錯誤描述（如有）    |          |
| data          | true     | object   |                     |          |
| { note        | false    | string   | API key備注         |          |
| permission    | false    | string   | API key權限         |          |
| ipAddresses } | false    | string   | API key綁定的IP地址 |          |

## 刪除子用戶API key

此接口用於母用戶刪除子用戶的API key

API Key 權限：交易

### HTTP 請求

- POST `/v2/sub-user/api-key-deletion`

### 請求參數

| 參數名稱  | 是否必須 | 類型   | 描述                      | 默認值 | 取值範圍 |
| --------- | -------- | ------ | ------------------------- | ------ | -------- |
| subUid    | true     | long   | 子用戶的uid               | NA     |          |
| accessKey | true     | string | 子用戶API key的access key | NA     |          |

> Response:

```json
{
    "code": 200,
    "data": null
}
```

### 響應數據

| 參數名稱 | 是否必須 | 數據類型 | 描述             | 取值範圍 |
| -------- | -------- | -------- | ---------------- | -------- |
| code     | true     | int      | 狀態碼           |          |
| message  | false    | string   | 錯誤描述（如有） |          |

## 資產划轉（母子用戶之間）

API Key 權限：交易<br>
限頻值（NEW）：2次/2s

母用戶執行母子用戶之間的划轉

### HTTP 請求

- POST ` /v1/subuser/transfer`

### 請求參數

| 參數     | 是否必填 | 數據類型 | 說明                                                         | 取值範圍                                                     |
| -------- | -------- | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| sub-uid  | true     | long     | 子用戶uid                                                    | -                                                            |
| currency | true     | string   | 幣種，即btc, ltc, bch, eth, etc ...(取值參考`GET /v1/common/currencys`) | -                                                            |
| amount   | true     | decimal  | 划轉金額                                                     | -                                                            |
| type     | true     | string   | 划轉類型                                                     | master-transfer-in（子用戶划轉給母用戶虛擬幣）/ master-transfer-out （母用戶划轉給子用戶虛擬幣） |

> Response:

```json
{
  "data":123456,
  "status":"ok"
}
```

### 響應數據

| 參數   | 是否必填 | 數據類型 | 長度 | 說明       | 取值範圍        |
| ------ | -------- | -------- | ---- | ---------- | --------------- |
| data   | true     | int      | -    | 划轉訂單id | -               |
| status | true     |          | -    | 狀態       | "OK" or "Error" |

### 錯誤碼

| error_code                                  | 說明                             | 類型   |
| ------------------------------------------- | -------------------------------- | ------ |
| account-transfer-balance-insufficient-error | 賬戶餘額不足                     | string |
| base-operation-forbidden                    | 禁止操作（母子用戶關係錯誤時報） | string |

## 子用戶充幣地址查詢

此節點用於母用戶查詢子用戶特定幣種（IOTA除外）在其所在區塊鏈中的充幣地址，限母用戶可用

API Key 權限：讀取

### HTTP 請求

- GET  `/v2/sub-user/deposit-address`

### 請求參數

| 字段名稱 | 是否必需 | 類型   | 描述      | 默認值 | 取值範圍                                                     |
| -------- | -------- | ------ | --------- | ------ | ------------------------------------------------------------ |
| subUid   | true     | long   | 子用戶UID | NA     | 限填1個                                                      |
| currency | true     | string | 幣種      | NA     | btc, ltc, bch, eth, etc ...(取值參考`GET /v1/common/currencys`) |

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

### 響應數據

| 字段名稱   | 是否必需 | 數據類型 | 字段描述         | 取值範圍 |
| ---------- | -------- | -------- | ---------------- | -------- |
| code       | true     | int      | 狀態碼           |          |
| message    | false    | string   | 錯誤描述（如有） |          |
| data       | true     | object   |                  |          |
| { currency | true     | string   | 幣種             |          |
| address    | true     | string   | 充幣地址         |          |
| addressTag | true     | string   | 充幣地址標籤     |          |
| chain }    | true     | string   | 鏈名稱           |          |


## 子用戶充幣記錄查詢

此節點用於母用戶查詢子用戶充值記錄，限母用戶可用

API Key 權限：讀取

### HTTP 請求

- GET `/v2/sub-user/query-deposit`

### 請求參數

| 參數名稱  | 數據類型 | 是否必需 | 描述                                                  |
| --------- | -------- | -------- | ----------------------------------------------------- |
| subUid    | long     | TRUE     | 子用戶UID，限填1個                                    |
| currency  | string   | FALSE    | 幣種，缺省值所有幣種                                  |
| startTime | long     | FALSE    | 遠點時間，以createTime進行檢索，取值範圍及缺省值見注1 |
| endTime   | long     | FALSE    | 近點時間，以createTime進行檢索，取值範圍及缺省值見注2 |
| sort      | string   | FALSE    | 檢索方向，asc 由遠及近, desc 由近及遠，缺省值desc     |
| limit     | int      | FALSE    | 單頁最大返回條目數量 [1,500] （缺省值100）            |
| fromId    | long     | FALSE    | 起始充幣訂單ID，僅在下頁查詢時有效見注3               |

注1：<br>
startTime取值範圍：[(endTime - 30天), endTime]<br>
startTime缺省值：(endTime - 30天)<br>

注2：<br>
endTime取值範圍：不限<br>
endTime缺省值：當前時間<br>

注3：<br>
僅當用戶請求查詢的時間範圍內的數據條目超出單頁限制（由「limit「字段設定）時，服務器才返回」nextId「字段。用戶收到服務器返回的」nextId「後 –<br>
1）須知曉後續仍有數據未能在本頁返回；<br>
2）如需繼續查詢下頁數據，應再次請求查詢並將服務器返回的「nextId」作為「fromId「，其它請求參數不變。<br>
3）作為數據庫記錄ID，「nextId」和「fromId」除了用來翻頁查詢外，無其它業務含義。<br>


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

### 響應數據

| 參數名稱     | 是否必須 | 數據類型   | 描述                                                         | 取值範圍     |
| ------------ | -------- | ---------- | ------------------------------------------------------------ | ------------ |
| code         | true     | int        | 狀態碼                                                       |              |
| message      | false    | string     | 錯誤描述（如有）                                             |              |
| data         | true     | object     |                                                              |              |
| {  id        | true     | long       | 充幣訂單id                                                   |              |
| currency     | true     | string     | 幣種                                                         |              |
| txHash       | true     | string     | 交易哈希                                                     |              |
| chain        | true     | string     | 鏈名稱                                                       |              |
| amount       | true     | bigdecimal | 個數                                                         |              |
| address      | true     | string     | 地址                                                         |              |
| addressTag   | true     | string     | 地址標籤                                                     |              |
| state        | true     | string     | 狀態                                                         | 狀態參見下表 |
| createTime   | true     | long       | 發起時間                                                     |              |
| updateTime } | true     | long       | 最後更新時間                                                 |              |
| nextId       | false    | long       | 下頁起始編號（充幣訂單ID，僅在查詢結果需要分頁返回時，包含此字段） |              |

- 虛擬幣充值狀態定義：

| 狀態       | 描述     |
| ---------- | -------- |
| unknown    | 狀態未知 |
| confirming | 確認中   |
| confirmed  | 已確認   |
| safe       | 已完成   |
| orphan     | 待確認   |

## 子用戶餘額（匯總）

API Key 權限：讀取<br>
限頻值（NEW）：2次/2s

母用戶查詢其下所有子用戶的各幣種匯總餘額

### HTTP 請求

- GET `/v1/subuser/aggregate-balance`

### 請求參數

無

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

### 響應數據

| 參數   | 是否必填 | 數據類型 | 長度 | 說明 | 取值範圍        |
| ------ | -------- | -------- | ---- | ---- | --------------- |
| status | true     |          | -    | 狀態 | "OK" or "Error" |
| data   | true     | list     | -    |      | -               |

- data 

參數|是否必填 | 數據類型 | 長度 | 說明 | 取值範圍 |
-----------|------------|-----------|------------|----------|--|--
currency|	是|	string|	-|幣種|-|	
type|	是	|string|	-	|賬戶類型| spot：現貨賬戶 |
balance|	是|	string|	-|賬戶餘額（可用餘額和凍結餘額的總和）|-|

## 子用戶餘額

API Key 權限：讀取<br>
限頻值（NEW）：20次/2s

母用戶查詢子用戶各幣種賬戶餘額

### HTTP 請求

- GET `/v1/account/accounts/{sub-uid}`

### 請求參數

| 參數    | 是否必填 | 數據類型 | 長度 | 說明         | 取值範圍 |
| ------- | -------- | -------- | ---- | ------------ | -------- |
| sub-uid | true     | long     | -    | 子用戶的 UID | -        |

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

### 響應數據

參數|是否必填 | 數據類型 | 長度 | 說明 | 取值範圍 |
-----------|------------|-----------|------------|----------|--|--
id|	-	|long|	-	|子用戶 UID|-|	
type|	-	|string|	-	|賬戶類型| spot：現貨賬戶 |
list|	-	|object|	-	|-|-|

- list

| 參數     | 是否必填 | 數據類型 | 長度 | 說明     | 取值範圍                          |
| -------- | -------- | -------- | ---- | -------- | --------------------------------- |
| currency | -        | string   | -    | 幣種     | -                                 |
| type     | -        | string   | -    | 賬戶類型 | trade：交易賬戶，frozen：凍結賬戶 |
| balance  | -        | decimal  | -    | 賬戶餘額 | -                                 |

# 現貨交易

## 簡介

現貨交易接口提供了下單、撤單、訂單查詢、成交查詢、手續費率查詢等功能。

<aside class="notice">訪問交易相關的接口需要進行簽名認證。</aside>

以下是交易相關接口返回的返回碼以及說明。

| 返回碼                                                       | 說明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| base-argument-unsupported                                    | 某參數不支持，請檢查參數                                     |
| base-system-error                                            | 系統錯誤，如果是撤單：緩存中查不到訂單狀態，該訂單無法撤單；如果是下單：訂單入緩存失敗，請再次嘗試 |
| login-required                                               | url中沒有Signature參數或找不到此用戶（key與賬戶id不對應等情況） |
| parameter-required                                           | 止盈止損訂單缺少參數 stop-price或operator                    |
| base-record-invalid                                          | 暫時未找到數據，請稍後重試                                   |
| order-amount-over-limit                                      | 訂單數量超出限額                                             |
| base-symbol-trade-disabled                                   | 該交易對被禁止交易                                           |
| base-operation-forbidden                                     | 用戶不在白名單內或該幣種不允許OTC交易等禁止行為              |
| account-get-accounts-inexistent-error                        | 該賬戶在該用戶下不存在                                       |
| account-account-id-inexistent                                | 該賬戶不存在                                                 |
| order-disabled                                               | 交易對暫停，無法下單                                         |
| cancel-disabled                                              | 交易對暫停，無法撤單                                         |
| order-invalid-price                                          | 下單價格非法（如市價單不能有價格，或限價單價格超過市場價10%） |
| order-accountbalance-error                                   | 賬戶餘額不足                                                 |
| order-limitorder-price-min-error                             | 賣出價格不能低於指定價格                                     |
| order-limitorder-price-max-error                             | 買入價格不能高於指定價格                                     |
| order-limitorder-amount-min-error                            | 下單數量不能低於指定數量                                     |
| order-limitorder-amount-max-error                            | 下單數量不能高於指定數量                                     |
| order-etp-nav-price-min-error                                | 下單價格不能低於淨值的指定比率                               |
| order-etp-nav-price-max-error                                | 下單價格不能高於淨值等指定比率                               |
| order-orderprice-precision-error                             | 交易價格精度錯誤                                             |
| order-orderamount-precision-error                            | 交易數額精度錯誤                                             |
| order-value-min-error                                        | 訂單交易額不能低於指定額度                                   |
| order-marketorder-amount-min-error                           | 賣出數量不能低於指定數量                                     |
| order-marketorder-amount-buy-max-error                       | 市價單買入額度不能高於指定額度                               |
| order-marketorder-amount-sell-max-error                      | 市價單賣出數量不能高於指定數量                               |
| order-holding-limit-failed                                   | 下單超出該幣種的持倉限額                                     |
| order-type-invalid                                           | 訂單類型非法                                                 |
| order-orderstate-error                                       | 訂單狀態錯誤                                                 |
| order-date-limit-error                                       | 查詢時間不能超過系統限制                                     |
| order-source-invalid                                         | 訂單來源非法                                                 |
| order-update-error                                           | 更新數據錯誤                                                 |
| order-user-cancel-forbidden                                  | 訂單類型為IOC 不允許撤單                                     |
| order-price-greater-than-limit                               | 下單價格高於開盤前下單限制價格，請重新下單                   |
| order-price-less-than-limit                                  | 下單價格低於開盤前下單限制價格，請重新下單                   |
| order-stop-order-hit-trigger                                 | 止盈止損單下單被當前價觸發                                   |
| market-orders-not-support-during-limit-price-trading         | 限時下單不支持市價單                                         |
| price-exceeds-the-protective-price-during-limit-price-trading | 限價時間內價格超出保護價                                     |
| invalid-client-order-id                                      | client order id 已重復                                       |
| invalid-interval                                             | 查詢起止窗口設置錯誤                                         |
| invalid-start-date                                           | 查詢起始日期含非法取值                                       |
| invalid-end-date                                             | 查詢起始日期含非法取值                                       |
| invalid-start-time                                           | 查詢起始時間含非法取值                                       |
| invalid-end-time                                             | 查詢起始時間含非法取值                                       |
| validation-constraints-required                              | 指定的必填參數缺失                                           |
| not-found                                                    | 撤單時訂單不存在                                             |
| base-not-found                                               | 撤單時無效clientorderid撤單過多，一個小時後再重試            |

## 下單

API Key 權限：交易
限頻值；100次/2s

發送一個新訂單以進行撮合。

### HTTP 請求

- POST ` /v1/order/orders/place`

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

### 請求參數

| 參數名稱        | 數據類型 | 是否必需 | 默認值   | 描述                                                         |
| --------------- | -------- | -------- | -------- | ------------------------------------------------------------ |
| account-id      | string   | true     | NA       | 賬戶 ID，取值參考 `GET /v1/account/accounts`。現貨交易使用 ‘spot’ 賬戶的 account-id |
| symbol          | string   | true     | NA       | 交易對,即btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |
| type            | string   | true     | NA       | 訂單類型，包括buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker（說明見下文）, buy-stop-limit, sell-stop-limit |
| amount          | string   | true     | NA       | 訂單交易量（市價買單為訂單交易額）                           |
| price           | string   | false    | NA       | 訂單價格（對市價單無效）                                     |
| source          | string   | false    | spot-api | 現貨交易填寫「spot-api」                                       |
| client-order-id | string   | false    | NA       | 用戶自編訂單號（最大長度64個字符，須在24小時內保持唯一性）   |
| stop-price      | string   | false    | NA       | 止盈止損訂單觸發價格                                         |
| operator        | string   | false    | NA       | 止盈止損訂單觸發價運算符 gte – greater than and equal (>=), lte – less than and equal (<=) |


**buy-limit-maker**

當「下單價格」>=「市場最低賣出價」，訂單提交後，系統將拒絕接受此訂單；

當「下單價格」<「市場最低賣出價」，提交成功後，此訂單將被系統接受。

**sell-limit-maker**

當「下單價格」<=「市場最高買入價」，訂單提交後，系統將拒絕接受此訂單；

當「下單價格」>「市場最高買入價」，提交成功後，此訂單將被系統接受。

> Response:

```json
{  
  "data": "59378"
}
```

### 響應數據

返回的主數據對象是一個對應下單單號的字符串。

如client order ID（在24小時內）被復用，節點將返回錯誤消息invalid.client.order.id。

## 批量下單

API Key 權限：交易<br>
限頻值（NEW）：50次/2s<br>

一個批量最多10張訂單

### HTTP 請求

- POST ` /v1/order/batch-orders`

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

### 請求參數

| 參數名稱        | 數據類型 | 是否必需 | 默認值   | 描述                                                         |
| --------------- | -------- | -------- | -------- | ------------------------------------------------------------ |
| [{ account-id   | string   | true     | NA       | 賬戶 ID，取值參考 `GET /v1/account/accounts`。現貨交易使用 ‘spot’ 賬戶的 account-id； |
| symbol          | string   | true     | NA       | 交易對,即btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |
| type            | string   | true     | NA       | 訂單類型，包括buy-market, sell-market, buy-limit, sell-limit, buy-ioc, sell-ioc, buy-limit-maker, sell-limit-maker（說明見下文）, buy-stop-limit, sell-stop-limit |
| amount          | string   | true     | NA       | 訂單交易量（市價買單為訂單交易額）                           |
| price           | string   | false    | NA       | 訂單價格（對市價單無效）                                     |
| source          | string   | false    | spot-api | 現貨交易填寫「spot-api」                                       |
| client-order-id | string   | false    | NA       | 用戶自編訂單號（最大長度64個字符，須在24小時內保持唯一性）   |
| stop-price      | string   | false    | NA       | 止盈止損訂單觸發價格                                         |
| operator }]     | string   | false    | NA       | 止盈止損訂單觸發價運算符 gte – greater than and equal (>=), lte – less than and equal (<=) |

**buy-limit-maker**

當「下單價格」>=「市場最低賣出價」，訂單提交後，系統將拒絕接受此訂單；

當「下單價格」<「市場最低賣出價」，提交成功後，此訂單將被系統接受。

**sell-limit-maker**

當「下單價格」<=「市場最高買入價」，訂單提交後，系統將拒絕接受此訂單；

當「下單價格」>「市場最高買入價」，提交成功後，此訂單將被系統接受。

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

### 響應數據

| 字段名稱        | 數據類型 | 描述                                 |
| --------------- | -------- | ------------------------------------ |
| [{ order-id     | integer  | 訂單編號                             |
| client-order-id | string   | 用戶自編訂單號（如有）               |
| err-code        | string   | 訂單被拒錯誤碼（僅對被拒訂單有效）   |
| err-msg }]      | string   | 訂單被拒錯誤信息（僅對被拒訂單有效） |

如client order ID（在24小時內）被復用，節點返回先前訂單的order ID及client order ID。

## 撤銷訂單

API Key 權限：交易<br>
限頻值（NEW）：100次/2s

此接口發送一個撤銷訂單的請求。

<aside class="warning">此接口只提交取消請求，實際取消結果需要通過訂單狀態，撮合狀態等接口來確認。</aside>

### HTTP 請求

- POST ` /v1/order/orders/{order-id}/submitcancel`


### 請求參數

| 參數名稱 | 是否必須 | 類型   | 描述               | 默認值 | 取值範圍 |
| -------- | -------- | ------ | ------------------ | ------ | -------- |
| order-id | true     | string | 訂單ID，填在path中 |        |          |


> Success response:

```json
{  
  "data": "59378"
}
```

### 響應數據

返回的主數據對象是一個對應下單單號的字符串。

### 錯誤碼

> Failure response:

```json
{
  "status": "error",
  "err-code": "order-orderstate-error",
  "err-msg": "訂單狀態錯誤",
  "order-state":-1 // 當前訂單狀態
}
```

返回字段列表中，order-state的可能取值包括 -

| order-state | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| -1          | order was already closed in the long past (order state = canceled, partial-canceled, filled, partial-filled) |
| 5           | partial-canceled                                             |
| 6           | filled                                                       |
| 7           | canceled                                                     |
| 10          | cancelling                                                   |

## 撤銷訂單（基於client order ID）

API Key 權限：交易<br>
限頻值（NEW）：100次/2s

此接口發送一個撤銷訂單的請求。

<aside class="warning">此接口只提交取消請求，實際取消結果需要通過訂單狀態，撮合狀態等接口來確認。</aside>

### HTTP 請求

- POST ` /v1/order/orders/submitCancelClientOrder`

> Request:

```json
{
  "client-order-id": "a0001"
}
```

### 請求參數

| 參數名稱        | 是否必須 | 類型   | 描述           | 默認值 | 取值範圍 |
| --------------- | -------- | ------ | -------------- | ------ | -------- |
| client-order-id | true     | string | 用戶自編訂單號 |        |          |


> Response:

```json
{  
  "data": "10"
}
```

### 響應數據

| 字段名稱 | 數據類型 | 描述       |
| -------- | -------- | ---------- |
| data     | integer  | 撤單狀態碼 |

| Status Code | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| -1          | order was already closed in the long past (order state = canceled, partial-canceled, filled, partial-filled) |
| 0           | client-order-id not found                                    |
| 5           | partial-canceled                                             |
| 6           | filled                                                       |
| 7           | canceled                                                     |
| 10          | cancelling                                                   |


## 查詢當前未成交訂單

API Key 權限：讀取<br>
限頻值（NEW）：50次/2s

查詢已提交但是仍未完全成交或未被撤銷的訂單。

### HTTP 請求

- GET `/v1/order/openOrders`

> Request:

```json
{
   "account-id": "100009",
   "symbol": "ethusdt",
   "side": "buy"
}
```

### 請求參數

| 參數名稱   | 數據類型 | 是否必需                                         | 默認值 | 描述                                                         |
| ---------- | -------- | ------------------------------------------------ | ------ | ------------------------------------------------------------ |
| account-id | string   | true                                             | NA     | 賬戶 ID，取值參考 `GET /v1/account/accounts`。現貨交易使用‘spot’賬戶的 account-id |
| symbol     | string   | ture                                             | NA     | 交易對,即btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |
| side       | string   | false                                            | both   | 指定只返回某一個方向的訂單，可能的值有: buy, sell. 默認兩個方向都返回。 |
| from       | string   | false                                            |        | 查詢起始 ID                                                  |
| direct     | string   | false (如字段'from'已設定，此字段'direct'為必填) |        | 查詢方向，prev 向前；next 向後                               |
| size       | int      | false                                            | 100    | 返回訂單的數量，最大值500。                                  |

> Response:

```json
{  
  "data": [
    {
      "id": 5454937,
      "symbol": "ethusdt",
      "account-id": 30925,
      "amount": "1.000000000000000000",
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

### 響應數據

| 字段名稱           | 數據類型 | 描述                                                         |
| ------------------ | -------- | ------------------------------------------------------------ |
| id                 | integer  | 訂單id，無大小順序，可作為下一次翻頁查詢請求的from字段       |
| client-order-id    | string   | 用戶自編訂單號（所有open訂單可返回client-order-id）          |
| symbol             | string   | 交易對, 例如btcusdt, ethbtc                                  |
| price              | string   | limit order的交易價格                                        |
| created-at         | int      | 訂單創建的調整為新加坡時間的時間戳，單位毫秒                 |
| type               | string   | 訂單類型                                                     |
| filled-amount      | string   | 訂單中已成交部分的數量                                       |
| filled-cash-amount | string   | 訂單中已成交部分的總價格                                     |
| filled-fees        | string   | 已交交易手續費總額                                           |
| source             | string   | 現貨交易填寫「api」                                            |
| state              | string   | 訂單狀態，包括submitted, partial-filled, cancelling, created |
| stop-price         | string   | 止盈止損訂單觸發價格                                         |
| operator           | string   | 止盈止損訂單觸發價運算符                                     |

## 批量撤銷訂單（open orders）

API Key 權限：交易<br>
限頻值（NEW）：50次/2s

此接口發送批量撤銷訂單的請求。

<aside class="warning">此接口只提交取消請求，實際取消結果需要通過訂單狀態，撮合狀態等接口來確認。</aside>

### HTTP 請求

- POST ` /v1/order/orders/batchCancelOpenOrders`


### 請求參數

| 參數名稱   | 是否必須 | 類型   | 描述                                                         | 默認值 | 取值範圍                                          |
| ---------- | -------- | ------ | ------------------------------------------------------------ | ------ | ------------------------------------------------- |
| account-id | false    | string | 賬戶ID，取值參考 `GET /v1/account/accounts`                  |        |                                                   |
| symbol     | false    | string | 交易代碼列表（最多10 個symbols，多個交易代碼間以逗號分隔），btcusdt, ethbtc...（取值參考`/v1/common/symbols`） | all    |                                                   |
| side       | false    | string | 主動交易方向                                                 |        | 「buy」或「sell」，缺省將返回所有符合條件尚未成交訂單 |
| size       | false    | int    | 所需返回記錄數                                               | 100    | [0,100]                                           |


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


### 響應數據


| 參數名稱      | 是否必須 | 數據類型 | 描述                       | 取值範圍 |
| ------------- | -------- | -------- | -------------------------- | -------- |
| success-count | true     | int      | 成功取消的訂單數           |          |
| failed-count  | true     | int      | 取消失敗的訂單數           |          |
| next-id       | true     | long     | 下一個符合取消條件的訂單號 |          |

## 批量撤銷訂單

API Key 權限：交易<br>
限頻值（NEW）：50次/2s

此接口同時為多個訂單（基於id）發送取消請求。

### HTTP 請求

- POST ` /v1/order/orders/batchcancel`

> Request:

```json
{
  "client-order-ids": [
   "5983466", "5722939", "5721027", "5719487"
  ]
}
```

### 請求參數

| 參數名稱         | 是否必須 | 類型     | 描述                                                         | 默認值 | 取值範圍           |
| ---------------- | -------- | -------- | ------------------------------------------------------------ | ------ | ------------------ |
| order-ids        | false    | string[] | 訂單編號列表（order-ids和client-order-ids必須且只能選一個填寫，不超過50張訂單） |        | 單次不超過50個訂單 |
| client-order-ids | false    | string[] | 用戶自編訂單號列表（order-ids和client-order-ids必須且只能選一個填寫，不超過50張訂單） |        | 單次不超過50個訂單 |

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

### 響應數據

| 字段名稱  | 數據類型 | 描述                                                         |
| --------- | -------- | ------------------------------------------------------------ |
| { success | string[] | 撤單成功訂單列表（可為order-id列表或client-order-id列表，以用戶請求為準） |
| failed }  | string[] | 撤單失敗訂單列表（可為order-id列表或client-order-id列表，以用戶請求為準） |

撤單失敗訂單列表 -

| 字段名稱        | 數據類型 | 描述                                                         |
| --------------- | -------- | ------------------------------------------------------------ |
| [{ order-id     | string   | 訂單編號（如用戶創建訂單時包含order-id，返回中也須包含此字段） |
| client-order-id | string   | 用戶自編訂單號（如用戶創建訂單時包含client-order-id，返回中也須包含此字段） |
| err-code        | string   | 訂單被拒錯誤碼（僅對被拒訂單有效）                           |
| err-msg         | string   | 訂單被拒錯誤信息（僅對被拒訂單有效）                         |
| order-state }]  | string   | 當前訂單狀態（若有）                                         |

返回字段列表中，order-state的可能取值包括 -

| order-state | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| -1          | order was already closed in the long past (order state = canceled, partial-canceled, filled, partial-filled) |
| 5           | partial-canceled                                             |
| 6           | filled                                                       |
| 7           | canceled                                                     |
| 10          | cancelling                                                   |

## 查詢訂單詳情

API Key 權限：讀取<br>
限頻值（NEW）：50次/2s

此接口返回指定訂單的最新狀態和詳情。通過API創建的訂單，撤銷超過2小時後無法查詢。

### HTTP 請求

- GET `/v1/order/orders/{order-id}`


### 請求參數

| 參數名稱 | 是否必須 | 類型   | 描述               | 默認值 | 取值範圍 |
| -------- | -------- | ------ | ------------------ | ------ | -------- |
| order-id | true     | string | 訂單ID，填在path中 |        |          |


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

### 響應數據

| 字段名稱          | 是否必須 | 數據類型 | 描述                                                         | 取值範圍                                                     |
| ----------------- | -------- | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| account-id        | true     | long     | 賬戶 ID                                                      |                                                              |
| amount            | true     | string   | 訂單數量                                                     |                                                              |
| canceled-at       | false    | long     | 訂單撤銷時間                                                 |                                                              |
| created-at        | true     | long     | 訂單創建時間                                                 |                                                              |
| field-amount      | true     | string   | 已成交數量                                                   |                                                              |
| field-cash-amount | true     | string   | 已成交總金額                                                 |                                                              |
| field-fees        | true     | string   | 已成交手續費（買入為幣，賣出為錢）                           |                                                              |
| finished-at       | false    | long     | 訂單變為終結態的時間，不是成交時間，包含「已撤單」狀態         |                                                              |
| id                | true     | long     | 訂單ID                                                       |                                                              |
| client-order-id   | false    | string   | 用戶自編訂單號（所有open訂單可返回client-order-id（如有）；僅7天內（基於訂單創建時間）的closed訂單（state <> canceled）可返回client-order-id（如有）；僅24小時內（基於訂單創建時間）的closed訂單（state = canceled）可返回client-order-id（如有）） |                                                              |
| price             | true     | string   | 訂單價格                                                     |                                                              |
| source            | true     | string   | 訂單來源                                                     | api                                                          |
| state             | true     | string   | 訂單狀態                                                     | submitted 已提交, partial-filled 部分成交, partial-canceled 部分成交撤銷, filled 完全成交, canceled 已撤銷， created |
| symbol            | true     | string   | 交易對                                                       | btcusdt, ethbtc, rcneth ...                                  |
| type              | true     | string   | 訂單類型                                                     | buy-market：市價買, sell-market：市價賣, buy-limit：限價買, sell-limit：限價賣, buy-ioc：IOC買單, sell-ioc：IOC賣單， buy-limit-maker, sell-limit-maker, buy-stop-limit，sell-stop-limit |
| stop-price        | false    | string   | 止盈止損訂單觸發價格                                         |                                                              |
| operator          | false    | string   | 止盈止損訂單觸發價運算符                                     | gte,lte                                                      |


## 查詢訂單詳情（基於client order ID）

API Key 權限：讀取<br>
限頻值（NEW）：50次/2s

此接口返回指定用戶自編訂單號（24小時內）的訂單最新狀態和詳情。通過API創建的訂單，撤銷超過2小時後無法查詢。

### HTTP 請求

- GET `/v1/order/orders/getClientOrder`

### 請求參數

| 參數名稱      | 是否必須 | 類型   | 描述           | 默認值 | 取值範圍 |
| ------------- | -------- | ------ | -------------- | ------ | -------- |
| clientOrderId | true     | string | 用戶自編訂單號 |        |          |

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

### 響應數據

| 字段名稱          | 是否必須 | 數據類型 | 描述                                                         | 取值範圍                                                     |
| ----------------- | -------- | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| account-id        | true     | long     | 賬戶 ID                                                      |                                                              |
| amount            | true     | string   | 訂單數量                                                     |                                                              |
| canceled-at       | false    | long     | 訂單撤銷時間                                                 |                                                              |
| created-at        | true     | long     | 訂單創建時間                                                 |                                                              |
| field-amount      | true     | string   | 已成交數量                                                   |                                                              |
| field-cash-amount | true     | string   | 已成交總金額                                                 |                                                              |
| field-fees        | true     | string   | 已成交手續費（買入為幣，賣出為錢）                           |                                                              |
| finished-at       | false    | long     | 訂單變為終結態的時間，不是成交時間，包含「已撤單」狀態         |                                                              |
| id                | true     | long     | 訂單ID                                                       |                                                              |
| client-order-id   | false    | string   | 用戶自編訂單號（僅24小時內（基於訂單創建時間）的訂單可被查詢.） |                                                              |
| price             | true     | string   | 訂單價格                                                     |                                                              |
| source            | true     | string   | 訂單來源                                                     | api                                                          |
| state             | true     | string   | 訂單狀態                                                     | submitted 已提交, partial-filled 部分成交, partial-canceled 部分成交撤銷, filled 完全成交, canceled 已撤銷，created |
| symbol            | true     | string   | 交易對                                                       | btcusdt, ethbtc, rcneth ...                                  |
| type              | true     | string   | 訂單類型                                                     | buy-market：市價買, sell-market：市價賣, buy-limit：限價買, sell-limit：限價賣, buy-ioc：IOC買單, sell-ioc：IOC賣單， buy-limit-maker, sell-limit-maker, buy-stop-limit，sell-stop-limit |
| stop-price        | false    | string   | 止盈止損訂單觸發價格                                         |                                                              |
| operator          | false    | string   | 止盈止損訂單觸發價運算符                                     | gte,lte                                                      |

如client order ID不存在，返回如下錯誤信息 
{
    "status": "error",
    "err-code": "base-record-invalid",
    "err-msg": "record invalid",
    "data": null
}

## 成交明細

API Key 權限：讀取<br>
限頻值（NEW）：50次/2s

此接口返回指定訂單的成交明細。

### HTTP 請求

- GET `/v1/order/orders/{order-id}/matchresults`

### 請求參數

| 參數名稱 | 是否必須 | 類型   | 描述               | 默認值 | 取值範圍 |
| -------- | -------- | ------ | ------------------ | ------ | -------- |
| order-id | true     | string | 訂單ID，填在path中 |        |          |


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

### 響應數據

<aside class="notice">返回的主數據對象為一個對象數組，其中每一個元件代表一個交易結果。</aside>

| 字段名稱            | 是否必須 | 數據類型 | 描述                                                         | 取值範圍                                                     |
| ------------------- | -------- | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| created-at          | true     | long     | 成交時間戳timestamp                                          |                                                              |
| filled-amount       | true     | string   | 成交數量                                                     |                                                              |
| filled-fees         | true     | string   | 交易手續費（正值）或交易返傭金（負值）                       |                                                              |
| fee-currency        | true     | string   | 交易手續費或交易返傭幣種（買單的交易手續費幣種為基礎幣種，賣單的交易手續費幣種為計價幣種；買單的交易返傭幣種為計價幣種，賣單的交易返傭幣種為基礎幣種） |                                                              |
| id                  | true     | long     | 訂單成交記錄ID                                               |                                                              |
| match-id            | true     | long     | 撮合ID，訂單在撮合中執行的順序ID                             |                                                              |
| order-id            | true     | long     | 訂單ID，成交所屬訂單的ID                                     |                                                              |
| trade-id            | false    | integer  | Unique trade ID (NEW)唯一成交編號，成交時產生的唯一編號ID    |                                                              |
| price               | true     | string   | 成交價格                                                     |                                                              |
| source              | true     | string   | 訂單來源                                                     | api                                                          |
| symbol              | true     | string   | 交易對                                                       | btcusdt, ethbtc, rcneth ...                                  |
| type                | true     | string   | 訂單類型                                                     | buy-market：市價買, sell-market：市價賣, buy-limit：限價買, sell-limit：限價賣, buy-ioc：IOC買單, sell-ioc：IOC賣單， buy-limit-maker, sell-limit-maker, buy-stop-limit，sell-stop-limit |
| role                | true     | string   | 成交角色                                                     | maker,taker                                                  |
| filled-points       | true     | string   | 抵扣數量（可為ht或hbpoint）                                  |                                                              |
| fee-deduct-currency | true     | string   | 抵扣類型                                                     | 如果為空，代表扣除的手續費是原幣；代表抵扣手續費的是抵扣資產 |
| fee-deduct-state    | true     | string   | 抵扣狀態                                                     | 抵扣中：ongoing，抵扣完成：done                              |

注：<br>

- filled-fees中的交易返傭金額可能不會實時到賬。<br>

## 搜索歷史訂單

API Key 權限：讀取<br>
限頻值（NEW）：50次/2s

此接口基於搜索條件查詢歷史訂單。通過API創建的訂單，撤銷超過2小時後無法查詢。

用戶可選擇以「時間範圍」查詢歷史訂單，以替代原先的以「日期範圍「查詢方式。

-	如用戶填寫start-time AND/OR end-time查詢歷史訂單，服務器將按照用戶指定的「時間範圍「查詢並返回，並忽略start-date/end-date參數。此方式的查詢窗口大小限定為最大48小時，窗口平移範圍為最近180天。

-	如用戶不填寫start-time/end-time參數，而填寫start-date AND/OR end-date查詢歷史訂單，服務器將按照用戶指定的「日期範圍「查詢並返回。此方式的查詢窗口大小限定為最大2天，窗口平移範圍為最近180天。

-	如用戶既不填寫start-time/end-time參數，也不填寫start-date/end-date參數，服務器將缺省以當前時間為end-time，返回最近48小時內的歷史訂單。

建議用戶以「時間範圍「查詢歷史訂單。


### HTTP 請求

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


### 請求參數

| 參數名稱   | 是否必須 | 類型   | 描述                                                         | 默認值                      | 取值範圍                                                     |
| ---------- | -------- | ------ | ------------------------------------------------------------ | --------------------------- | ------------------------------------------------------------ |
| symbol     | true     | string | 交易對                                                       |                             | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`）       |
| types      | false    | string | 查詢的訂單類型組合，使用逗號分割                             |                             | buy-market：市價買, sell-market：市價賣, buy-limit：限價買, sell-limit：限價賣, buy-ioc：IOC買單, sell-ioc：IOC賣單， buy-limit-maker, sell-limit-maker, buy-stop-limit，sell-stop-limit |
| start-time | false    | long   | 查詢開始時間, 時間格式UTC time in millisecond。 以訂單生成時間進行查詢 | -48h 查詢結束時間的前48小時 | 取值範圍 [((end-time) – 48h), (end-time)] ，查詢窗口最大為48小時，窗口平移範圍為最近180天，已完全撤銷的歷史訂單的查詢窗口平移範圍只有最近2小時(state="canceled") |
| end-time   | false    | long   | 查詢結束時間, 時間格式UTC time in millisecond。 以訂單生成時間進行查詢 | present                     | 取值範圍 [(present-179d), present] ，查詢窗口最大為48小時，窗口平移範圍為最近180天，已完全撤銷的歷史訂單的查詢窗口平移範圍只有最近2小時(state="canceled") |
| start-date | false    | string | 查詢開始日期, 日期格式yyyy-mm-dd。 以訂單生成時間進行查詢    | -1d 查詢結束日期的前1天     | 取值範圍 [((end-date) – 1), (end-date)] ，查詢窗口最大為2天，窗口平移範圍為最近180天，已完全撤銷的歷史訂單的查詢窗口平移範圍只有最近2小時(state="canceled") |
| end-date   | false    | string | 查詢結束日期, 日期格式yyyy-mm-dd。 以訂單生成時間進行查詢    | today                       | 取值範圍 [(today-179), today] ，查詢窗口最大為2天，窗口平移範圍為最近180天，已完全撤銷的歷史訂單的查詢窗口平移範圍只有最近2小時(state="canceled") |
| states     | true     | string | 查詢的訂單狀態組合，使用','分割                              |                             | submitted 已提交, partial-filled 部分成交, partial-canceled 部分成交撤銷, filled 完全成交, canceled 已撤銷，created |
| from       | false    | string | 查詢起始 ID                                                  |                             | 如果是向後查詢，則賦值為上一次查詢結果中得到的最後一條id ；如果是向前查詢，則賦值為上一次查詢結果中得到的第一條id |
| direct     | false    | string | 查詢方向                                                     |                             | prev 向前；next 向後                                         |
| size       | false    | string | 查詢記錄大小                                                 | 100                         | [1, 100]                                                     |


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

### 響應數據

| 參數名稱          | 是否必須 | 數據類型 | 描述                                                         | 取值範圍                                                     |
| ----------------- | -------- | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| account-id        | true     | long     | 賬戶 ID                                                      |                                                              |
| amount            | true     | string   | 訂單數量                                                     |                                                              |
| canceled-at       | false    | long     | 接到撤單申請的時間                                           |                                                              |
| created-at        | true     | long     | 訂單創建時間                                                 |                                                              |
| field-amount      | true     | string   | 已成交數量                                                   |                                                              |
| field-cash-amount | true     | string   | 已成交總金額                                                 |                                                              |
| field-fees        | true     | string   | 已成交手續費（買入為基礎幣，賣出為計價幣）                   |                                                              |
| finished-at       | false    | long     | 最後成交時間                                                 |                                                              |
| id                | true     | long     | 訂單ID，無大小順序，可作為下一次翻頁查詢請求的from字段       |                                                              |
| client-order-id   | false    | string   | 用戶自編訂單號（所有open訂單可返回client-order-id（如有）；僅7天內（基於訂單創建時間）的closed訂單（state <> canceled）可返回client-order-id（如有）；僅24小時內（基於訂單創建時間）的closed訂單（state = canceled）可被查詢） |                                                              |
| price             | true     | string   | 訂單價格                                                     |                                                              |
| source            | true     | string   | 訂單來源                                                     | api                                                          |
| state             | true     | string   | 訂單狀態                                                     | submitted 已提交, partial-filled 部分成交, partial-canceled 部分成交撤銷, filled 完全成交, canceled 已撤銷，created |
| symbol            | true     | string   | 交易對                                                       | btcusdt, ethbtc, rcneth ...                                  |
| type              | true     | string   | 訂單類型                                                     | submit-cancel：已提交撤單申請  ,buy-market：市價買, sell-market：市價賣, buy-limit：限價買, sell-limit：限價賣, buy-ioc：IOC買單, sell-ioc：IOC賣單， buy-limit-maker, sell-limit-maker, buy-stop-limit，sell-stop-limit |
| stop-price        | false    | string   | 止盈止損訂單觸發價格                                         |                                                              |
| operator          | false    | string   | 止盈止損訂單觸發價運算符                                     | gte,lte                                                      |

### start-date, end-date相關錯誤碼

| 錯誤碼             | 對應錯誤場景                                                 |
| ------------------ | ------------------------------------------------------------ |
| invalid_interval   | start date小於end date; 或者 start date 與end date之間的時間間隔大於2天 |
| invalid_start_date | start date是一個180天之前的日期；或者start date是一個未來的日期 |
| invalid_end_date   | end date 是一個180天之前的日期；或者end date是一個未來的日期 |

## 搜索最近48小時內歷史訂單

API Key 權限：讀取<br>
限頻值（NEW）：20次/2s

此接口基於搜索條件查詢最近48小時內歷史訂單。通過API創建的訂單，撤銷超過2小時後無法查詢。

### HTTP 請求

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

### 請求參數

| 參數名稱   | 是否必須 | 類型   | 描述                                                         | 默認值         | 取值範圍                                               |
| ---------- | -------- | ------ | ------------------------------------------------------------ | -------------- | ------------------------------------------------------ |
| symbol     | false    | string | 交易對                                                       | all            | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |
| start-time | false    | long   | 查詢起始時間（含）                                           | 48小時前的時刻 | UTC time in millisecond                                |
| end-time   | false    | long   | 查詢結束時間（含）                                           | 查詢時刻       | UTC time in millisecond                                |
| direct     | false    | string | 訂單查詢方向（注：僅在檢索出的總條目數量超出size字段限定時起作用；如果檢索出的總條目數量在size 字段限定內，direct 字段不起作用。） | next           | prev 向前, next 向後                                   |
| size       | false    | int    | 每次返回條目數量                                             | 100            | [10,1000]                                              |

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

### 響應數據

| 參數名稱          | 是否必須 | 數據類型 | 描述                                                         | 取值範圍                                                     |
| ----------------- | -------- | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| {account-id       | true     | long     | 賬戶 ID                                                      |                                                              |
| amount            | true     | string   | 訂單數量                                                     |                                                              |
| canceled-at       | false    | long     | 接到撤單申請的時間                                           |                                                              |
| created-at        | true     | long     | 訂單創建時間                                                 |                                                              |
| field-amount      | true     | string   | 已成交數量                                                   |                                                              |
| field-cash-amount | true     | string   | 已成交總金額                                                 |                                                              |
| field-fees        | true     | string   | 已成交手續費（買入為基礎幣，賣出為計價幣）                   |                                                              |
| finished-at       | false    | long     | 最後成交時間                                                 |                                                              |
| id                | true     | long     | 訂單ID，無大小順序                                           |                                                              |
| client-order-id   | false    | string   | 用戶自編訂單號（僅48小時內（基於訂單創建時間）的closed訂單（state <> canceled）可返回client-order-id（如有）；僅24小時內（基於訂單創建時間）的closed訂單（state = canceled）可被查詢） |                                                              |
| price             | true     | string   | 訂單價格                                                     |                                                              |
| source            | true     | string   | 訂單來源                                                     | api                                                          |
| state             | true     | string   | 訂單狀態                                                     | partial-canceled 部分成交撤銷, filled 完全成交, canceled 已撤銷 |
| symbol            | true     | string   | 交易對                                                       | btcusdt, ethbtc, rcneth ...                                  |
| stop-price        | false    | string   | 止盈止損訂單觸發價格                                         |                                                              |
| operator          | false    | string   | 止盈止損訂單觸發價運算符                                     | gte,lte                                                      |
| type}             | true     | string   | 訂單類型                                                     | buy-market：市價買, sell-market：市價賣, buy-limit：限價買, sell-limit：限價賣, buy-ioc：IOC買單, sell-ioc：IOC賣單, buy-limit-maker, sell-limit-maker, buy-limit-maker, sell-limit-maker |
| next-time         | false    | long     | 下一查詢起始時間（當請求字段」direct」為」prev」時有效）, 下一查詢結束時間（當請求字段」direct」為」next」時有效）。注：僅在檢索出的總條目數量超出size字段限定時，此返回字段存在。 | UTC time in millisecond                                      |


## 當前和歷史成交

API Key 權限：讀取<br>
限頻值（NEW）：20次/2s

此接口基於搜索條件查詢當前和歷史成交記錄。

### HTTP 請求

- GET `/v1/order/matchresults`


### 請求參數

| 參數名稱   | 是否必須 | 類型   | 描述                                           | 默認值                  | 取值範圍                                                     |
| ---------- | -------- | ------ | ---------------------------------------------- | ----------------------- | ------------------------------------------------------------ |
| symbol     | true     | string | 交易對                                         | N/A                     | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`）       |
| types      | false    | string | 查詢的訂單類型組合，使用','分割                | all                     | buy-market：市價買, sell-market：市價賣, buy-limit：限價買, sell-limit：限價賣, buy-ioc：IOC買單, sell-ioc：IOC賣單, buy-limit-maker, sell-limit-maker, buy-stop-limit, sell-stop-limit |
| start-date | false    | string | 查詢開始日期（新加坡時區）日期格式yyyy-mm-dd   | -1d 查詢結束日期的前1天 | 取值範圍 [((end-date) – 1), (end-date)] ，查詢窗口最大為2天，窗口平移範圍為最近61天。 |
| end-date   | false    | string | 查詢結束日期（新加坡時區）, 日期格式yyyy-mm-dd | today                   | 取值範圍 [(today-60), today] ，查詢窗口最大為2天，窗口平移範圍為最近61天 |
| from       | false    | string | 查詢起始 ID                                    | N/A                     | 如果是向後查詢，則賦值為上一次查詢結果中得到的最後一條id（不是trade-id） ；如果是向前查詢，則賦值為上一次查詢結果中得到的第一條id（不是trade-id） |
| direct     | false    | string | 查詢方向                                       | next                    | prev 向前；next 向後                                         |
| size       | false    | string | 查詢記錄大小                                   | 100                     | [1，500]                                                     |

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

### 響應數據

<aside class="notice">返回的主數據對象為一個對象數組，其中每一個元件代表一個交易結果。</aside>

| 參數名稱            | 是否必須 | 數據類型 | 描述                                                         | 取值範圍                                                     |
| ------------------- | -------- | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| created-at          | true     | long     | 成交時間戳timestamp                                          |                                                              |
| filled-amount       | true     | string   | 成交數量                                                     |                                                              |
| filled-fees         | true     | string   | 交易手續費（正值）或交易返傭（負值）                         |                                                              |
| fee-currency        | true     | string   | 交易手續費或交易返傭幣種（買單的交易手續費幣種為基礎幣種，賣單的交易手續費幣種為計價幣種；買單的交易返傭幣種為計價幣種，賣單的交易返傭幣種為基礎幣種） |                                                              |
| id                  | true     | long     | 訂單成交記錄 ID，無大小順序，可作為下一次翻頁查詢請求的from字段 |                                                              |
| match-id            | true     | long     | 撮合 ID                                                      |                                                              |
| order-id            | true     | long     | 訂單 ID                                                      |                                                              |
| trade-id            | false    | integer  | 唯一成交編號                                                 |                                                              |
| price               | true     | string   | 成交價格                                                     |                                                              |
| source              | true     | string   | 訂單來源                                                     | api                                                          |
| symbol              | true     | string   | 交易對                                                       | btcusdt, ethbtc, rcneth ...                                  |
| type                | true     | string   | 訂單類型                                                     | buy-market：市價買, sell-market：市價賣, buy-limit：限價買, sell-limit：限價賣, buy-ioc：IOC買單, sell-ioc：IOC賣單， buy-limit-maker, sell-limit-maker, buy-stop-limit，sell-stop-limit |
| role                | true     | string   | 成交角色                                                     | maker,taker                                                  |
| filled-points       | true     | string   | 抵扣數量（可為ht或hbpoint）                                  |                                                              |
| fee-deduct-currency | true     | string   | 抵扣類型                                                     |                                                              |
| fee-deduct-state    | true     | string   | 抵扣狀態                                                     | 抵扣中：ongoing，抵扣完成：done                              |

注：<br>

- filled-fees中的交易返傭金額可能不會實時到賬；<br>

### start-date, end-date相關錯誤碼 

| 錯誤碼             | 對應錯誤場景                                                 |
| ------------------ | ------------------------------------------------------------ |
| invalid_interval   | start date小於end date; 或者 start date 與end date之間的時間間隔大於2天 |
| invalid_start_date | start date是一個61天之前的日期；或者start date是一個未來的日期 |
| invalid_end_date   | end date 是一個61天之前的日期；或者end date是一個未來的日期  |


## 獲取用戶當前手續費率

Api用戶查詢交易對費率，一次限制最多查10個交易對，子用戶的費率和母用戶保持一致

API Key 權限：讀取

```shell
curl "https://api.bitv.com/v2/reference/transact-fee-rate?symbols=btcusdt,ethusdt,ltcusdt"
```

### HTTP 請求

- GET `/v2/reference/transact-fee-rate`

### 請求參數

| 參數    | 數據類型 | 是否必須 | 默認值 | 描述                     | 取值範圍                                                |
| ------- | -------- | -------- | ------ | ------------------------ | ------------------------------------------------------- |
| symbols | string   | true     | NA     | 交易對，可多填，逗號分隔 | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`）> |

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

### 響應數據

| 字段名稱          | 數據類型 | 描述                                                         |
| ----------------- | -------- | ------------------------------------------------------------ |
| code              | integer  | 狀態碼                                                       |
| message           | string   | 錯誤描述（如有）                                             |
| data              | object   |                                                              |
| { symbol          | string   | 交易代碼                                                     |
| makerFeeRate      | string   | 基礎費率 - 被動方，如適用交易手續費返傭，返回返傭費率（負值） |
| takerFeeRate      | string   | 基礎費率 - 主動方                                            |
| actualMakerRate   | string   | 抵扣後費率 - 被動方，如不適用抵扣或未啓用抵扣，返回基礎費率；如適用交易手續費返傭，返回返傭費率（負值） |
| actualTakerRate } | string   | 抵扣後費率 – 主動方，如不適用抵扣或未啓用抵扣，返回基礎費率  |

注：<br>

- 如makerFeeRate/actualMakerRate為正值，該字段意為交易手續費率；<br>
- 如makerFeeRate/actualMakerRate為負值，該字段意為交易返傭費率。<br>


# Websocket行情數據

## 簡介

### 接入URL

**行情請求地址**

**`wss://api.bitv.com/ws`**  

### 數據壓縮

WebSocket 行情接口返回的所有數據都進行了 GZIP 壓縮，需要 client 在收到數據之後解壓。

### 心跳消息

```json
{"ping": 1492420473027} 
```

當用戶的Websocket客戶端連接到Websocket服務器後，服務器會定期（當前設為5秒）向其發送`ping`消息並包含一整數值。

```json
{"pong": 1492420473027} 
```

當用戶的Websocket客戶端接收到此心跳消息後，應返回`pong`消息並包含同一整數值。

<aside class="warning">當Websocket服務器連續兩次發送了`ping`消息卻沒有收到任何一次`pong`消息返回後，服務器將主動斷開與此客戶端的連接。</aside>

### 訂閱主題

> Sub request:

```json
{
  "sub": "market.btcusdt.kline.1min",
  "id": "id1"
}
```

成功建立與Websocket服務器的連接後，Websocket客戶端發送請求以訂閱特定主題：

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

成功訂閱後，Websocket客戶端將收到確認。

之後, 一旦所訂閱的主題有更新，Websocket客戶端將收到服務器推送的更新消息（push）。

### 取消訂閱

> UnSub request:

```json
{
  "unsub": "market.btcusdt.trade.detail",
  "id": "id4"
}
```

取消訂閱的格式如下：

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

取消訂閱成功確認。

### 請求數據

Websocket服務器同時支持一次性請求數據（pull）。

一次性請求的格式如下：

{
  "req": "topic to req",
  "id": "id generate by client"
}

一次性返回數據的具體格式參見各個主題。

### 限頻

數據請求（req）限頻規則

單個連接每兩次請求不能小於100ms。

### 錯誤碼

以下是WebSocket行情接口的錯誤碼、錯誤消息和說明。

| 錯誤碼      | 錯誤消息                               | 說明                     |
| ----------- | -------------------------------------- | ------------------------ |
| bad-request | invalid topic                          | topic錯誤                |
| bad-request | invalid symbol                         | symbol錯誤               |
| bad-request | symbol trade not open now              | 該交易對未到開始交易時間 |
| bad-request | 429 too many request                   | req 請求太頻繁           |
| bad-request | unsub with not subbed topic            | 未訂閱該主題             |
| bad-request | not json string                        | 發送的請求不是JSON格式   |
| 1008        | header required correct cloud-exchange | exchangeCode 參數錯誤    |
| bad-request | request timeout                        | 請求超時                 |

## K線數據

### 主題訂閱

一旦K線數據產生，Websocket服務器將通過此訂閱主題接口推送至客戶端：

`market.$symbol$.kline.$period$`

> 訂閱請求

```json
{
  "sub": "market.ethbtc.kline.1min",
  "id": "id1"
}
```

### 參數

| 參數   | 數據類型 | 是否必需 | 描述     | 取值範圍                                                     |
| ------ | -------- | -------- | -------- | ------------------------------------------------------------ |
| symbol | string   | true     | 交易代碼 | btcusdt, ethbtc...等                                         |
| period | string   | true     | K線週期  | 1min, 5min, 15min, 30min, 60min, 4hour, 1day, 1mon, 1week, 1year |

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

### 數據更新字段列表

| 字段   | 數據類型 | 描述                                        |
| ------ | -------- | ------------------------------------------- |
| id     | integer  | unix時間，同時作為K線ID                     |
| amount | float    | 成交量                                      |
| count  | integer  | 成交筆數                                    |
| open   | float    | 開盤價                                      |
| close  | float    | 收盤價（當K線為最晚的一根時，是最新成交價） |
| low    | float    | 最低價                                      |
| high   | float    | 最高價                                      |
| vol    | float    | 成交額, 即 sum(每一筆成交價 * 該筆的成交量) |


### 數據請求

用請求方式一次性獲取K線數據需要額外提供以下參數：
（每次最多返回300條）

```json
{
  "req": "market.$symbol.kline.$period",
  "id": "id generated by client",
  "from": "from time in epoch seconds",
  "to": "to time in epoch seconds"
}
```

| 參數 | 數據類型 | 是否必需 | 缺省值                                | 描述                            | 取值範圍                                                     |
| ---- | -------- | -------- | ------------------------------------- | ------------------------------- | ------------------------------------------------------------ |
| from | integer  | false    | 1501174800(2017-07-28T00:00:00+08:00) | 起始時間 (epoch time in second) | [1501174800, 2556115200]                                     |
| to   | integer  | false    | 2556115200(2050-01-01T00:00:00+08:00) | 結束時間 (epoch time in second) | [1501174800, 2556115200] or ($from, 2556115200] if "from" is set |

## 市場深度行情數據

此主題發送最新市場深度快照。快照頻率為每秒1次。

### 主題訂閱

`market.$symbol.depth.$type`

> Subscribe request

```json
{
  "sub": "market.btcusdt.depth.step0",
  "id": "id1"
}
```

### 參數

| 參數   | 數據類型 | 是否必需 | 缺省值 | 描述         | 取值範圍                                               |
| ------ | -------- | -------- | ------ | ------------ | ------------------------------------------------------ |
| symbol | string   | true     | NA     | 交易代碼     | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |
| type   | string   | true     | step0  | 合併深度類型 | step0, step1, step2, step3, step4, step5               |

**"type" 合併深度類型**

| Value | Description                          |
| ----- | ------------------------------------ |
| step0 | 不合併深度                           |
| step1 | Aggregation level = precision*10     |
| step2 | Aggregation level = precision*100    |
| step3 | Aggregation level = precision*1000   |
| step4 | Aggregation level = precision*10000  |
| step5 | Aggregation level = precision*100000 |

當type值為‘step0’時，默認深度為150檔;
當type值為‘step1’,‘step2’,‘step3’,‘step4’,‘step5’時，默認深度為20檔。

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

### 數據更新字段列表

<aside class="notice">在'tick'object下方呈現買盤賣盤深度列表</aside>

| 字段    | 數據類型 | 描述                         |
| ------- | -------- | ---------------------------- |
| bids    | object   | 當前的所有買單 [price, size] |
| asks    | object   | 當前的所有賣單 [price, size] |
| version | integer  | 內部字段                     |
| ts      | integer  | 新加坡時間的時間戳，單位毫秒 |

<aside class="notice">當symbol被設為"hb10"時，amount, count, vol均為零值 </aside>

### 數據請求

支持數據請求方式一次性獲取市場深度數據：

```json
{
  "req": "market.btcusdt.depth.step0",
  "id": "id10"
}
```

## 市場深度MBP行情數據（增量推送）

用戶可訂閱此頻道以接收最新深度行情Market By Price (MBP) 的增量數據推送；同時，該頻道支持用戶以req方式請求獲取全量數據。

**MBP增量推送及MBP全量REQ請求地址**

**`wss://api.bitv.com/feed`**  

建議下游數據處理方式：<br>
1）	訂閱增量數據並開始緩存；<br>
2）	請求全量數據（同等檔位數）並根據該全量消息的seqNum與緩存增量數據中的prevSeqNum對齊；<br>
3）	開始連續增量數據接收與計算，構建並持續更新MBP訂單簿；<br>
4）	每條增量數據的prevSeqNum須與前一條增量數據的seqNum一致，否則意味著存在增量數據丟失，須重新獲取全量數據並對齊；<br>
5）	如果收到增量數據包含新增price檔位，須將該price檔位插入MBP訂單簿中適當位置；<br>
6）	如果收到增量數據包含已有price檔位，但size不同，須替換MBP訂單簿中該price檔位的size；<br>
7）	如果收到增量數據某price檔位的size為0值，須將該price檔位從MBP訂單簿中刪除；<br>
8）	如果收到單條增量數據中包含兩個及以上price檔位的更新，這些price檔位須在MBP訂單簿中被同時更新。<br>

當前僅支持5檔/20檔MBP逐筆增量以及150檔MBP快照增量的推送，二者的區別為 -<br>
1） 深度不同；<br>
2） 5檔/20檔為逐筆增量MBP行情，150檔為100毫秒定時快照增量MBP行情；<br>
3） 當5檔/20檔訂單簿僅發生單邊行情變化時，增量推送僅包含單邊行情更新，比如，推送消息中包含數組asks，但不含數組bids；<br>

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

當150檔訂單簿僅發生單邊行情變化時，增量推送包含雙邊行情更新，但其中一邊行情為空，比如，推送消息中包含數組asks更新的同時，也包含bids空數組；<br>

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

未來，150檔增量推送的數據行為將與5檔/20檔增量保持一致，即，單邊深度行情變更時，推送消息中將不包含另一邊行情深度行情；<br>
4） 當150檔訂單簿在100毫秒時間間隔內未發生變化時，增量推送包含bids和asks空數組；<br>

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

而5檔/20檔MBP逐筆增量，在訂單簿未發生變化時，不推送數據；<br>
未來，150檔增量推送的數據行為將與5檔增量保持一致，即，在訂單簿未發生變化時，不再推送空消息；<br>
5）5檔/20檔逐筆增量行情僅支持部分交易對（btcusdt,ethusdt,xrpusdt,eosusdt,ltcusdt,etcusdt,adausdt,dashusdt,bsvusdt），150檔快照增量支持全部交易對。<br>

REQ頻道支持5檔/20檔/150檔全量數據的獲取。<br>

### 訂閱增量推送

`market.$symbol.mbp.$levels`

> Sub request

```json
{
  "sub": "market.btcusdt.mbp.5",
  "id": "id1"
}
```

### 請求全量數據

`market.$symbol.mbp.$levels`

> Req request

```json
{
  "req": "market.btcusdt.mbp.5",
  "id": "id2"
}
```

### 參數

| 參數   | 數據類型 | 是否必需 | 缺省值 | 描述                         | 取值範圍                         |
| ------ | -------- | -------- | ------ | ---------------------------- | -------------------------------- |
| symbol | string   | true     | NA     | 交易代碼（不支持通配符）     |                                  |
| levels | integer  | true     | NA     | 深度檔位（取值：5, 20, 150） | 當前僅支持5檔，20檔，或150檔深度 |

> Response (增量訂閱)

```json
{
  "id": "id1",
  "status": "ok",
  "subbed": "market.btcusdt.mbp.5",
  "ts": 1489474081631 //system response time
}
```

> Incremental Update (增量訂閱)

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

> Response (全量請求)

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

### 數據更新字段列表

| 字段       | 數據類型 | 描述                                    |
| ---------- | -------- | --------------------------------------- |
| seqNum     | integer  | 消息序列號                              |
| prevSeqNum | integer  | 上一消息序列號                          |
| bids       | object   | 買盤，按price降序排列，["price","size"] |
| asks       | object   | 賣盤，按price升序排列，["price","size"] |

## 市場深度MBP行情數據（全量推送）

用戶可訂閱此頻道以接收最新深度行情Market By Price (MBP) 的全量數據推送。推送頻率為大約100毫秒一次。

### 訂閱增量推送

`market.$symbol.mbp.refresh.$levels`

> Sub request

```json
{
"sub": "market.btcusdt.mbp.refresh.20",
"id": "id1"
}
```

### 參數

| 參數   | 數據類型 | 是否必需 | 缺省值 | 描述                     | 取值範圍 |
| ------ | -------- | -------- | ------ | ------------------------ | -------- |
| symbol | string   | true     | NA     | 交易代碼（不支持通配符） |          |
| levels | integer  | true     | NA     | 深度檔位                 | 5,10,20  |

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
			[210.34, 94.463], ... // 省略余下15檔
   		],
		"asks": [
			[650.59, 14.909733438479636],
			[650.63, 97.996],
			[650.77, 97.465],
			[651.23, 83.973],
			[651.42, 34.465], ... // 省略余下15檔
		]
}
}
```

### 數據更新字段列表

| 字段   | 數據類型 | 描述                                    |
| ------ | -------- | --------------------------------------- |
| seqNum | integer  | 消息序列號                              |
| bids   | object   | 買盤，按price降序排列，["price","size"] |
| asks   | object   | 賣盤，按price升序排列，["price","size"] |


## 買一賣一逐筆行情

當買一價、買一量、賣一價、賣一量，其中任一數據發生變化時，此主題推送逐筆更新。

### 主題訂閱

`market.$symbol.bbo`

> Subscribe request

```json
{
  "sub": "market.btcusdt.bbo",
  "id": "id1"
}
```

### 參數

| 參數   | 數據類型 | 是否必需 | 缺省值 | 描述     | 取值範圍                                               |
| ------ | -------- | -------- | ------ | -------- | ------------------------------------------------------ |
| symbol | string   | true     | NA     | 交易代碼 | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |

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

### 數據更新字段列表

| 字段      | 數據類型 | 描述         |
| --------- | -------- | ------------ |
| symbol    | string   | 交易代碼     |
| quoteTime | long     | 盤口更新時間 |
| bid       | float    | 買一價       |
| bidSize   | float    | 買一量       |
| ask       | float    | 賣一價       |
| askSize   | float    | 賣一量       |
| seqId     | int      | 消息序號     |


## 成交明細

### 主題訂閱

此主題提供市場最新成交逐筆明細。

`market.$symbol.trade.detail`

> Subscribe request

```json
{
  "sub": "market.btcusdt.trade.detail",
  "id": "id1"
}
```

### 參數

| 參數   | 數據類型 | 是否必需 | 缺省值 | 描述     | 取值範圍                                               |
| ------ | -------- | -------- | ------ | -------- | ------------------------------------------------------ |
| symbol | string   | true     | NA     | 交易代碼 | btcusdt, ethbtc...（取值參考`GET /v1/common/symbols`） |

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

### 數據更新字段列表

| 字段      | 數據類型 | 描述                                           |
| --------- | -------- | ---------------------------------------------- |
| id        | integer  | 唯一成交ID（將被廢棄）                         |
| tradeId   | integer  | 唯一成交ID（NEW）                              |
| amount    | float    | 成交量（買或賣一方）                           |
| price     | float    | 成交價                                         |
| ts        | integer  | 成交時間 (UNIX epoch time in millisecond)      |
| direction | string   | 成交主動方 (taker的訂單方向) : 'buy' or 'sell' |

### 數據請求

支持數據請求方式一次性獲取成交明細數據（僅能獲取最多最近300個成交記錄）：

```json
{
  "req": "market.btcusdt.trade.detail",
  "id": "id11"
}
```

## 市場概要

### 主題訂閱

此主題提供24小時內最新市場概要快照。快照頻率不超過每秒10次。

`market.$symbol.detail`

> Subscribe request

```json
{
  "sub": "market.btcusdt.detail",
  "id": "id1"
}
```

### 參數

| 參數   | 數據類型 | 是否必需 | 缺省值 | 描述     | 取值範圍             |
| ------ | -------- | -------- | ------ | -------- | -------------------- |
| symbol | string   | true     | NA     | 交易代碼 | btcusdt, ethbtc...等 |

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
    "open":   9790.52,
    "close":  10195.00,
    "high":   10300.00,
    "id":     1494496390,
    "count":  15195,
    "low":    9657.00,
    "vol":    121906001.754751
  }
}
```

### 數據更新字段列表

| 字段   | 數據類型 | 描述                     |
| ------ | -------- | ------------------------ |
| id     | integer  | unix時間，同時作為消息ID |
| amount | float    | 24小時成交量             |
| count  | integer  | 24小時成交筆數           |
| open   | float    | 24小時開盤價             |
| close  | float    | 最新價                   |
| low    | float    | 24小時最低價             |
| high   | float    | 24小時最高價             |
| vol    | float    | 24小時成交額             |

### 數據請求

支持數據請求方式一次性獲取市場概要數據：

```json
{
  "req": "market.btcusdt.detail",
  "id": "id11"
}
```


## 


# Websocket資產及訂單

## 簡介

### 接入URL

**Websocket資產及訂單**

**`wss://api.bitv.com/ws/v2`**  

### 數據壓縮

數據未進行 GZIP 壓縮。

### 心跳消息

當用戶的Websocket客戶端連接到WebSocket服務器後，服務器會定期（當前設為20秒）向其發送`Ping`消息並包含一整數值如下：

```json
{
	"action": "ping",
	"data": {
		"ts": 1575537778295
	}
}
```

當用戶的Websocket客戶端接收到此心跳信息後，應返回`Pong`消息並包含同一整數值：

```json
{
    "action": "pong",
    "data": {
          "ts": 1575537778295 // 使用Ping消息中的ts值
    }
}
```

### `action`的有效取值

| 有效取值   | 取值說明                             |
| ---------- | ------------------------------------ |
| sub        | 訂閱數據                             |
| req        | 數據請求                             |
| ping、pong | 心跳數據                             |
| push       | 推送數據，服務端發送至客戶端數據類型 |

### 限頻

此版本對用戶採取了多維度的限頻策略，具體策略如下：

- 限制單連接**有效**的請求（包括req，sub，unsub，不包括ping/pong和其他無效請求)為**50次/秒**（此處秒限制為滑動窗口）。當超過此限制時，會返回"too many request"錯誤消息。
- 限制單API Key建連總數為**10**。當超過此限制時，會返回"too many connection"錯誤消息。
- 限制單IP建立連接數為**100次/秒**。當超過次限制時，會返回"too many request"錯誤消息。

### 鑒權

鑒權請求格式如下：

```json
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

```

鑒權成功後返回數據格式如下：

```json
{
	"action": "req",
	"code": 200,
	"ch": "auth",
	"data": {}
}
```

參數說明

| 字段             | 是否必需 | 數據類型 | 描述                                                         |
| ---------------- | -------- | -------- | ------------------------------------------------------------ |
| action           | true     | string   | Websocket數據操作類型，鑒權固定值為req                       |
| ch               | true     | string   | 請求主題，鑒權固定值為auth                                   |
| authType         | true     | string   | 鑒權類型，鑒權固定值為api。注意，該參數不在簽名計算中。      |
| accessKey        | true     | string   | 您申請的API Key中的AccessKey                                 |
| signatureMethod  | true     | string   | 簽名方法，用戶計算簽名寄語哈希的協議，固定值為HmacSHA256     |
| signatureVersion | true     | string   | 簽名協議版本，固定值為2.1                                    |
| timestamp        | true     | string   | 時間戳，您發出請求的時間（UTC時間）在查詢請求中包含此值有助於防止第三方截取您的請求。如：2017-05-11T16:22:06。再次強調是 (UTC 時區) |
| signature        | true     | string   | 簽名, 計算得出的值，用於確保簽名有效和未被篡改               |

### 簽名步驟

簽名步驟,您可以在【快速入門-簽名認證】部分進行查看。

注：JSON請求中的數據不需要URL編碼。

### 訂閱主題

成功建立與Websocket服務器的連接後，Websocket客戶端發送如下請求以訂閱特定主題：

```json
{
	"action": "sub",
	"ch": "accounts.update"
}
```

訂閱成功Websocket客戶端會接收到如下消息：

```json
{
	"action": "sub",
	"code": 200,
	"ch": "accounts.update#0",
	"data": {}
}
```

### 請求數據

成功建立Websocket服務器的連接後，Websocket客戶端發送如下請求用以獲取一次性數據：

```json
{
    "action": "req", 
    "ch": "topic",
}
```

請求成功後Websocket客戶端會收到如下消息：

```json
{
    "action": "req",
    "ch": "topic",
    "code": 200,
    "data": {} // 請求數據體
}
```

### 錯誤碼

以下是WebSocket資產和訂單接口的錯誤碼、錯誤消息和說明。

| 錯誤碼 | 錯誤消息                 | 說明                                         |
| ------ | ------------------------ | -------------------------------------------- |
| 200    | 正確                     | 正確返回                                     |
| 100    | 超時關閉                 | 超時關閉                                     |
| 400    | Bad Request              | 請求錯誤                                     |
| 404    | Not Found                | 找不到服務                                   |
| 429    | Too Many Requests        | 超過單機服務最大連接數或者超過單IP最大連接數 |
| 500    | 系統異常                 | 系統錯誤                                     |
| 2000   | invalid.ip               | 無效的ip                                     |
| 2001   | nvalid.json              | 無效的請求json                               |
| 2001   | invalid.authType         | 驗簽方式錯誤                                 |
| 2001   | invalid.action           | 無效的訂閱事件                               |
| 2001   | invalid.symbol           | 無效的交易對                                 |
| 2001   | invalid.ch               | 無效的訂閱                                   |
| 2001   | invalid.exchange         | 無效的交易所code                             |
| 2001   | missing.param.auth       | 缺少驗簽參數                                 |
| 2002   | invalid.auth.state       | 認證未通過                                   |
| 2002   | auth.fail                | 驗簽失敗                                     |
| 2003   | query.account.list.error | 查詢賬戶列表失敗                             |
| 4000   | too.many.request         | 客戶端上行請求限頻                           |
| 4000   | too.many.connection      | 同一個key的建聯數量                          |

## 訂閱訂單更新

API Key 權限：讀取

訂單的更新推送由任一以下事件觸發：<br>

- 計劃委託或追蹤委託觸發失敗事件（eventType=trigger）<br>
- 計劃委託或追蹤委託觸發前撤單事件（eventType=deletion）<br>
- 訂單創建（eventType=creation）<br>
- 訂單成交（eventType=trade）<br>
- 訂單撤銷（eventType=cancellation）<br>

不同事件類型所推送的消息中，字段列表略有不同。開發者可以採取以下兩種方式設計返回的數據結構：<br>

- 定義一個包含所有字段的數據結構，並允許某些字段為空<br>
- 定義不同的數據結構，分別包含各自的字段，並繼承自一個包含公共數據字段的數據結構

### 訂閱主題

` orders#${symbol}`

### 訂閱參數

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

| 參數   | 數據類型 | 描述                      |
| ------ | -------- | ------------------------- |
| symbol | string   | 交易代碼（支持通配符 * ） |

### 數據更新字段列表

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
	}
}
```

當計劃委託/追蹤委託觸發失敗後 –

| 字段          | 數據類型 | 描述                                                         |
| ------------- | -------- | ------------------------------------------------------------ |
| eventType     | string   | 事件類型，有效值：trigger（本事件僅對計劃委託/追蹤委託有效） |
| symbol        | string   | 交易代碼                                                     |
| clientOrderId | string   | 用戶自編訂單號                                               |
| orderSide     | string   | 訂單方向，有效值：buy,sell                                   |
| orderStatus   | string   | 訂單狀態，有效值：rejected                                   |
| errCode       | int      | 訂單觸發失敗錯誤碼                                           |
| errMessage    | string   | 訂單觸發失敗錯誤消息                                         |
| lastActTime   | long     | 訂單觸發失敗時間                                             |

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
		"orderStatus":"canceled",
		"symbol":"btcusdt",
		"eventType":"deletion"
	}
}
```

當計劃委託/追蹤委託在觸發前被撤銷後 –

| 字段          | 數據類型 | 描述                                                         |
| ------------- | -------- | ------------------------------------------------------------ |
| eventType     | string   | 事件類型，有效值：deletion（本事件僅對計劃委託/追蹤委託有效） |
| symbol        | string   | 交易代碼                                                     |
| clientOrderId | string   | 用戶自編訂單號                                               |
| orderSide     | string   | 訂單方向，有效值：buy,sell                                   |
| orderStatus   | string   | 訂單狀態，有效值：canceled                                   |
| lastActTime   | long     | 訂單撤銷時間                                                 |

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
	}
}

```

當訂單掛單後 –

| 字段            | 數據類型 | 描述                                                         |
| --------------- | -------- | ------------------------------------------------------------ |
| eventType       | string   | 事件類型，有效值：creation                                   |
| symbol          | string   | 交易代碼                                                     |
| accountId       | long     | 賬戶ID                                                       |
| orderId         | long     | 訂單ID                                                       |
| clientOrderId   | string   | 用戶自編訂單號（如有）                                       |
| orderPrice      | string   | 訂單價格                                                     |
| orderSize       | string   | 訂單數量（對市價買單無效）                                   |
| orderValue      | string   | 訂單金額（僅對市價買單有效）                                 |
| type            | string   | 訂單類型，有效值：buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell-limit-maker, buy-ioc, sell-ioc |
| orderStatus     | string   | 訂單狀態，有效值：submitted                                  |
| orderCreateTime | long     | 訂單創建時間                                                 |

注：<BR>

- 止盈止損訂單在尚未被觸發時，接口將不會推送此訂單的創建；<br>
- Taker訂單在成交前，接口首先推送其創建事件。<br>
- 止盈止損訂單的訂單類型不再是原始訂單類型「buy-stop-limit」或「sell-stop-limit」，而是變為「buy-limit」或「sell-limit」。<BR>

> Update example

```json
{
	"action":"push",
	"ch":"orders#btcusdt",
	"data":
	{
		"tradePrice":"76.000000000000000000",
		"tradeVolume":"1.013157894736842100",
		"tradeId":301,
		"tradeTime":1583854188883,
		"aggressor":true,
		"remainAmt":"0.000000000000000400000000000000000000",
		"orderId":27163536,
		"type":"sell-limit",
		"clientOrderId":"abc123",
		"orderStatus":"filled",
		"symbol":"btcusdt",
		"eventType":"trade"
	}
}
```

當訂單成交後 –

| 字段          | 數據類型 | 描述                                                         |
| ------------- | -------- | ------------------------------------------------------------ |
| eventType     | string   | 事件類型，有效值：trade                                      |
| symbol        | string   | 交易代碼                                                     |
| tradePrice    | string   | 成交價                                                       |
| tradeVolume   | string   | 成交量                                                       |
| orderId       | long     | 訂單ID                                                       |
| type          | string   | 訂單類型，有效值：buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell-limit-maker, buy-ioc, sell-ioc |
| clientOrderId | string   | 用戶自編訂單號（如有）                                       |
| tradeId       | long     | 成交ID                                                       |
| tradeTime     | long     | 成交時間                                                     |
| aggressor     | bool     | 是否交易主動方，有效值： true (taker), false (maker)         |
| orderStatus   | string   | 訂單狀態，有效值：partial-filled, filled                     |
| remainAmt     | string   | 未成交數量（市價買單為未成交金額）                           |

注：<BR>

- 止盈止損訂單的訂單類型不再是原始訂單類型「buy-stop-limit」或「sell-stop-limit」，而是變為「buy-limit」或「sell-limit」。<BR>
- 當一張taker訂單同時與對手方多張訂單成交後，所產生的每筆成交（tradePrice, tradeVolume, tradeTime, tradeId, aggressor）將被分別推送（而不是合併推送一筆）。<BR>

> Update example

```json
{
	"action":"push",
	"ch":"orders#btcusdt",
	"data":
	{
		"lastActTime":1583853475406,
		"remainAmt":"2.000000000000000000",
		"orderId":27163533,
		"type":"sell-limit",
		"clientOrderId":"abc123",
		"orderStatus":"canceled",
		"symbol":"btcusdt",
		"eventType":"cancellation"
	}
}
```

當訂單被撤銷後 –

| 字段          | 數據類型 | 描述                                                         |
| ------------- | -------- | ------------------------------------------------------------ |
| eventType     | string   | 事件類型，有效值：cancellation                               |
| symbol        | string   | 交易代碼                                                     |
| orderId       | long     | 訂單ID                                                       |
| type          | string   | 訂單類型，有效值：buy-market, sell-market, buy-limit, sell-limit, buy-limit-maker, sell-limit-maker, buy-ioc, sell-ioc |
| clientOrderId | string   | 用戶自編訂單號（如有）                                       |
| orderStatus   | string   | 訂單狀態，有效值：partial-canceled, canceled                 |
| remainAmt     | string   | 未成交數量（市價買單為未成交金額）                           |
| lastActTime   | long     | 訂單最近更新時間                                             |

注：<BR>

- 止盈止損訂單的訂單類型不再是原始訂單類型「buy-stop-limit」或「sell-stop-limit」，而是變為「buy-limit」或「sell-limit」。<BR>

## 訂閱清算後成交及撤單更新

API Key 權限：讀取

僅當用戶訂單成交或撤銷時推送。其中，訂單成交為逐筆推送，如一張 taker 訂單同時與多張 maker 訂單成交，該接口將推送逐筆更新。但用戶收到的這幾筆成交消息的次序，有可能與實際的成交次序不完全一致。另外，如果一張訂單的成交及撤銷幾乎同時發生，例如 IOC 訂單成交後剩餘部分被自動撤銷，用戶可能會先收到撤單推送，再收到成交推送。<br>

如用戶需要獲取依次更新的訂單推送，建議訂閱另一頻道 orders#${symbol}。<br>

### 訂閱主題

`trade.clearing#${symbol}#${mode}`

### 訂閱參數

| 參數   | 數據類型 | 是否必需 | 描述                                                         |
| ------ | -------- | -------- | ------------------------------------------------------------ |
| symbol | string   | TRUE     | 交易代碼（支持通配符 * ）                                    |
| mode   | int      | FALSE    | 推送模式（0 - 僅在訂單成交時推送；1 - 在訂單成交、撤銷時均推送；缺省值：0） |

注：<br>
可選訂閱參數 mode，如不填或填0，僅推送成交事件；如填1，推送成交及撤銷事件。<br>

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
    }
}
```

### 數據更新字段列表（當訂單成交後）

| 字段            | 數據類型 | 描述                                                         |
| --------------- | -------- | ------------------------------------------------------------ |
| eventType       | string   | 事件類型（trade）                                            |
| symbol          | string   | 交易代碼                                                     |
| orderId         | long     | 訂單ID                                                       |
| tradePrice      | string   | 成交價                                                       |
| tradeVolume     | string   | 成交量                                                       |
| orderSide       | string   | 訂單方向，有效值： buy, sell                                 |
| orderType       | string   | 訂單類型，有效值： buy-market, sell-market,buy-limit,sell-limit,buy-ioc,sell-ioc,buy-limit-maker,sell-limit-maker,buy-stop-limit,sell-stop-limit |
| aggressor       | bool     | 是否交易主動方，有效值： true, false                         |
| tradeId         | long     | 交易ID                                                       |
| tradeTime       | long     | 成交時間，unix time in millisecond                           |
| transactFee     | string   | 交易手續費（正值）或交易手續費返傭（負值）                   |
| feeCurrency     | string   | 交易手續費或交易手續費返傭幣種（買單的交易手續費幣種為基礎幣種，賣單的交易手續費幣種為計價幣種；買單的交易手續費返傭幣種為計價幣種，賣單的交易手續費返傭幣種為基礎幣種） |
| feeDeduct       | string   | 交易手續費抵扣                                               |
| feeDeductType   | string   | 交易手續費抵扣類型，有效值： ht, point                       |
| accountId       | long     | 賬戶編號                                                     |
| source          | string   | 訂單來源                                                     |
| orderPrice      | string   | 訂單價格 （市價單無此字段）                                  |
| orderSize       | string   | 訂單數量（市價買單無此字段）                                 |
| orderValue      | string   | 訂單金額（僅市價買單有此字段）                               |
| clientOrderId   | string   | 用戶自編訂單號                                               |
| stopPrice       | string   | 訂單觸發價（僅止盈止損訂單有此字段）                         |
| operator        | string   | 訂單觸發方向（僅止盈止損訂單有此字段）                       |
| orderCreateTime | long     | 訂單創建時間                                                 |
| orderStatus     | string   | 訂單狀態，有效值：filled, partial-filled                     |

注：<br>

- transactFee中的交易返傭金額可能不會實時到賬；<br>

### 數據更新字段列表（當訂單撤銷後）

| 字段            | 數據類型 | 描述                                                         |
| --------------- | -------- | ------------------------------------------------------------ |
| eventType       | string   | 事件類型（cancellation）                                     |
| symbol          | string   | 交易代碼                                                     |
| orderId         | long     | 訂單ID                                                       |
| orderSide       | string   | 訂單方向，有效值： buy, sell                                 |
| orderType       | string   | 訂單類型，有效值： buy-market, sell-market,buy-limit,sell-limit,buy-ioc,sell-ioc,buy-limit-maker,sell-limit-maker,buy-stop-limit,sell-stop-limit |
| accountId       | long     | 賬戶編號                                                     |
| source          | string   | 訂單來源                                                     |
| orderPrice      | string   | 訂單價格 （市價單無此字段）                                  |
| orderSize       | string   | 訂單數量（市價買單無此字段）                                 |
| orderValue      | string   | 訂單金額（僅市價買單有此字段）                               |
| clientOrderId   | string   | 用戶自編訂單號                                               |
| stopPrice       | string   | 訂單觸發價（僅止盈止損訂單有此字段）                         |
| operator        | string   | 訂單觸發方向（僅止盈止損訂單有此字段）                       |
| orderCreateTime | long     | 訂單創建時間                                                 |
| remainAmt       | string   | 未成交量（對於市價買單，該字段定義為未成交額）               |
| orderStatus     | string   | 訂單狀態，有效值：canceled, partial-canceled                 |

## 訂閱賬戶變更

API Key 權限：讀取

訂閱賬戶下的訂單更新。

### 訂閱主題

`accounts.update#${mode}`

用戶可選擇以下任一賬戶變更推送的觸發方式

1、僅在賬戶餘額發生變動時推送；

2、在賬戶餘額發生變動或可用餘額發生變動時均推送，且分別推送。

### 訂閱參數

| 參數 | 數據類型 | 描述                              |
| ---- | -------- | --------------------------------- |
| mode | integer  | 推送方式，有效值：0, 1，默認值：0 |

訂閱示例  
1、不填mode：  
accounts.update  
僅當賬戶餘額變動時推送；  
2、填寫mode=0：  
accounts.update#0  
僅當賬戶餘額變動時推送；  
3、填寫mode=1：  
accounts.update#1  
在賬戶餘額發生變動或可用餘額發生變動時均推送且分別推送。  

注：無論用戶採用哪種模式訂閱，在訂閱成功後，服務器將首先推送當前各賬戶的賬戶餘額與可用餘額，然後再推送後續的賬戶更新。在首推各賬戶初始值時，消息中的changeType和changeTime的值為null。

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
accounts.update#0：
{
	"action": "push",
	"ch": "accounts.update#0",
	"data": {
		"currency": "btc",
		"accountId": 123456,
		"balance": "23.111",
		"changeType": "transfer",
           	"accountType":"trade",
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
           	"accountType":"trade",
		"changeTime": 1574393385122
	}
}
```

### 數據更新字段列表

| 字段        | 數據類型 | 描述                                                         |
| ----------- | -------- | ------------------------------------------------------------ |
| currency    | string   | 幣種                                                         |
| accountId   | long     | 賬戶ID                                                       |
| balance     | string   | 賬戶餘額（僅當賬戶餘額發生變動時推送）                       |
| available   | string   | 可用餘額（僅當可用餘額發生變動時推送）                       |
| changeType  | string   | 餘額變動類型，有效值：order-place(訂單創建)，order-match(訂單成交)，order-refund(訂單成交退款)，order-cancel(訂單撤銷)，order-fee-refund(抵扣交易手續費) |
| accountType | string   | 賬戶類型，有效值：trade, frozen, loan, interest              |
| changeTime  | long     | 餘額變動時間，unix time in millisecond                       |

注：<br>
賬戶更新推送的是到賬金額，多筆成交產生的多筆交易返傭可能會合併到帳。

<br>
<br>
<br>
<br>
<br>
