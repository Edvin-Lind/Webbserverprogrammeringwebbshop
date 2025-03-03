<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <link
      rel="stylesheet"
      type="text/css"
      href="/style.css?<%=Time.now.to_i%>"
    />
  </head>
  <body>
    <h1><%= databas ['title'] %></h1>
    <p>price: <%= databas ['price'] %></p>
    <p>Desc: <%= databas ['description'] %></p>
    <p>stock: <%= databas ['stock'] %></p>

    <form action="/editor/<%= databas['id'] %>" method="post">
      <input type="hidden" name="_method" value="edit" />
      <input type="submit" value="Redigera" />
    </form>
  </body>
</html>
