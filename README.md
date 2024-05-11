# How to run the app

### Prerequisites
- Make sure to `cd` to project directory
- Have Docker engine installed


```bash
docker build -t prediction .
docker run -p 9000:9000 -d prediction
```

Now app is running at `http://127.0.0.1:9000/`