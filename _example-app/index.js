const express = require('express');
const app = express();
const axios = require('axios');
const port = 80;

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.get('/healthcheck', (req, res) => {
    res.send('Healthy, cough cough!');
  });

app.get('/externalApi', async (req, res) => {
  try {
    // Make an HTTP GET request to the public API
    const response = await axios.get('https://jsonplaceholder.typicode.com/posts');
    const data = response.data;

    // Return the API response as the result
    res.json(data);
  } catch (error) {
    console.error('Error:', error.message);
    res.status(500).send('An error occurred');
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});