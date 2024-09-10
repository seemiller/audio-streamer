# Audio Streamer

Demonstrates using the ElevenLabs API to convert text to speech via the streaming endpoint.

Setup the project by adding your ElevenLabs API key to the `.env` file:

```bash
cp .env.sample .env
```

Then, run the project:

```bash
rails s
```

See it in action by running a cURL command like this and opening the resulting file:

```bash
curl localhost:3000/stream/tts --progress-bar --output test.mp3
```
