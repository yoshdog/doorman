
1. Simple client & server
2. Since its a public endpoint we want to add some authorization. We will add a password.
3. Talk about crypto hashing
4. Talk about request signing and why
5. How Zendesk uses OAuth2 Mac
6. Implement doorman as a proxy

Basics to cover
- Stuff that makes up a HTTP Request
  - HEADERS
    - HOST header
  - URI
    - SCHEME
    - HOST
    - PATH
  - BODY

- One way hashing (crypto hasing) -> HS256
  - How it works
  - Comparing hashes

- Why we request sign
  - Man in the middle attack
  - Can alter your request on the way to the intended target
  - Verify that the request is the actual request that happened when signed
  - Signature
  - Different implementations of the same simple concept

- OAuth2 Mac
  https://tools.ietf.org/id/draft-hammer-oauth-v2-mac-token-00.html
  https://github.com/oauth-xx/oauth2/blob/master/lib/oauth2/mac_token.rb

  GET /resource/1 HTTP/1.1
  Host: example.com
  Authorization: MAC token='h480djs93hd8',
                     timestamp='137131200',
                     nonce='dj83hs9s',
                     signature='IdSrHQHTwCPWGrqzGGIR791ZJXE='

- If its a successful request, doorman will query the account service and add details about the account and user in a JWT token. The token is also signed by a doorman key.

The token is added to the `X-Zendesk-Doorman` header

Doorman will add a bunch of other headers like:
```
X-Zendesk-API-Version: v2
X-Zendesk-Doorman: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50Ijp7ImlkIj
  oxLCJzaGFyZF9pZCI6MX0sInVzZXIiOnsiaWQiOjEwMDAyLCJyb2xlIjoiMiJ9LCJ2aWEiOiJzZX
  NzaW9uIiwic2Vzc2lvbiI6eyJpZCI6IjcxZGM1N2E2NWM0ODllNjlhMmQ3MWJmNjcyMjkxZTdhOD
  ZkNGE3ZjY5NzE1MmYwYThkMzdhZmJkMThiMWFkZjUiLCJyZWNvcmRfaWQiOjEwMDA2fX0.JLITm5
  9cOjkc7iywbxws97wysm3xCf2_fAwWz7VNypw
X-Zendesk-Doorman-Auth-Response: 200
X-Zendesk-Origin-Server: zendesk.service.consul
X-Zendesk-Request-Id: 9a9c720458afa00058a0
X-Zendesk-User-Id: 10002
```

The request is then proxied to the downstream service where it will verify the doorman headers
