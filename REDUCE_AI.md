try one request and copy it as curl
them replace the token in it with the one given in the code

then open the console on the same website and run the following code

```js
async function humanizeText(prompt) {
  const url = "https://aihumanize.io/dev/outstream";

  const body = {
    prompt: prompt,
    token: "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6MTc3MzUxOTI2ODY4Njg3NDY2LCJuYW1lIjoiVGVtcG9yYXJ5IHVzZXIiLCJ0eXBlIjoyLCJkZXZpY2UiOjEsInN1cGVyUGFzc3dvcmRGbGFnIjpmYWxzZSwiaWF0IjoxNzczNTE5MjY4LCJleHAiOjE3NzQxMjQwNjh9.NVUeZvEMw-h5m3DzgU-OsXpw_2WDIJC3S5AAuMSWM9TLPQ08qGlBIWlNCYhQLuMHU0colM8DvT7Rwz-4JZHozA",
    auto: 0,
    cjtype: 0,
    model: 1
  };

  const response = await fetch(url, {
    method: "POST",
    headers: {
      "accept": "*/*",
      "content-type": "application/json"
    },
    body: JSON.stringify(body)
  });

  const reader = response.body.getReader();
  const decoder = new TextDecoder("utf-8");

  let fullText = "";

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;

    const chunk = decoder.decode(value, { stream: true });

    // SSE lines usually start with "data:"
    const lines = chunk.split("\n");
    for (const line of lines) {
      if (line.startsWith("data:")) {
        const data = line.replace("data:", "").trim();
        if (data && data !== "[DONE]") {
          fullText += data;
        }
      }
    }
  }

  return fullText;
}
```


```js
// ===== Usage =====
const prompt = `To be processed using raw sensor data (streams from the sensor) cleaning is needed. 
The readings are taken once every 10 minutes; short gaps (1-2 missed cycles) are filled via 
linear interpolation. For longer gaps, multivariate regression methods are used that consider 
the relationship between the variables.`;


humanizeText(prompt).then(result => {
  console.log("Final Text:");
  console.log(result);
});
```
