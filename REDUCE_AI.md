try one request and copy it as curl
them replace the token in it with the one given in the code

then open the console on the same website and run the following code

```js
async function humanize(prompt) {
  const res = await fetch("https://aihumanize.io/dev/outstream", {
    method: "POST",
    headers: {
      accept: "*/*",
      "content-type": "application/json"
    },
    body: JSON.stringify({
      prompt,
      token: "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6MTc3MzUxOTI2ODY4Njg3NDY2LCJuYW1lIjoiVGVtcG9yYXJ5IHVzZXIiLCJ0eXBlIjoyLCJkZXZpY2UiOjEsInN1cGVyUGFzc3dvcmRGbGFnIjpmYWxzZSwiaWF0IjoxNzczNTE5MjY4LCJleHAiOjE3NzQxMjQwNjh9.NVUeZvEMw-h5m3DzgU-OsXpw_2WDIJC3S5AAuMSWM9TLPQ08qGlBIWlNCYhQLuMHU0colM8DvT7Rwz-4JZHozA",
      auto: 0,
      cjtype: 0,
      model: 1
    })
  });

  const reader = res.body.getReader();
  const decoder = new TextDecoder();

  let output = "";

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;

    const chunk = decoder.decode(value);
    const matches = chunk.match(/\{.*?\}/g);

    if (!matches) continue;

    for (const m of matches) {
      try {
        const data = JSON.parse(m);

        if (data.type === "success") {
          output += data.msg;
        }

        if (data.type === "DONE") {
          console.log("Final Text:\n");
          console.log(output.trim());
          return;
        }
      } catch {}
    }
  }

  console.log("Final Text:\n");
  console.log(output.trim());
}
```


```js
// ===== Usage =====
humanize(`
The persistent limitation is measurement quality. LCA and carbon assessments
of these systems still largely depend on periodic manual sampling.
`);
```
