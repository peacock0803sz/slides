function handler(event) {
  var request = event.request;
  var path = request.uri;
  var host = request.headers.host.value;

  if (path === "/pyconus2022" || path === "/pyconus2022/") {
    var response = {
      statusCode: 301,
      statusDescription: "Moved Permanently",
      headers: {
        location: { value: `https://${host}/pyconus2022/index.html` },
      },
    };
    return response;
  } else {
    return request;
  }
}
