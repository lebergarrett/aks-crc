fetch ('https://44ts8mx4qf.execute-api.us-east-1.amazonaws.com/prod/getcount')
.then(x => x.text())
.then(y => document.getElementById("hits").innerHTML = y);