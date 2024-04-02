<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
  <title>JS Bin</title>
  <script>
    let gitRead = (user) => {
      fetch('https://api.github.com/users/'+user)
        .then(data => data.json())
        .then(data=>console.log(data)); 
    }
  </script>
</head>
<body>
<input type="text" id='in'>
    <button onclick='gitRead(document.getElementById("in").value)'>Press Me</button>
    <p>output the name and list of repos under here:</p>
</body>
</html>