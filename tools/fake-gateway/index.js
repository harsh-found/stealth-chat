const http = require('http');
const WebSocket = require('ws');

const PORT = parseInt(process.env.GATEWAY_PORT || '3001', 10);

const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', service: 'fake-gateway', timestamp: Date.now() }));
    return;
  }
  res.writeHead(404);
  res.end();
});

const wss = new WebSocket.Server({ server });

// In-memory conversation state
// conversationId -> { lastSeq: number, messages: Array<MessageNew> }
const conversations = new Map();

// Client connection tracking
// ws -> { deviceId, userId, authenticated: boolean }
const clients = new Map();

function getConversation(convId) {
  if (!conversations.has(convId)) {
    conversations.set(convId, { lastSeq: 0, messages: [] });
  }
  return conversations.get(convId);
}

function parseFrame(data) {
  try {
    if (Buffer.isBuffer(data) || data instanceof ArrayBuffer) {
      const str = Buffer.from(data).toString('utf-8');
      return JSON.parse(str);
    }
    if (typeof data === 'string') {
      return JSON.parse(data);
    }
  } catch (err) {
    return null;
  }
  return null;
}

function sendFrame(ws, frame) {
  if (ws.readyState === WebSocket.OPEN) {
    const payload = Buffer.from(JSON.stringify(frame), 'utf-8');
    ws.send(payload);
  }
}

wss.on('connection', (ws) => {
  clients.set(ws, { authenticated: false });
  console.log('[fake-gateway] Client connected. Total sockets:', clients.size);

  ws.on('message', (data) => {
    const clientFrame = parseFrame(data);
    if (!clientFrame) {
      console.warn('[fake-gateway] Malformed frame received');
      return;
    }

    const { req_id, v } = clientFrame;
    const body = clientFrame;

    // Handle Hello
    if (body.hello) {
      const { access_token, device_id, sync_token } = body.hello;
      clients.set(ws, {
        authenticated: true,
        deviceId: device_id,
        userId: 'user-' + (device_id || 'test').slice(0, 8),
      });

      console.log(`[fake-gateway] Authenticated device=${device_id}`);

      const helloOk = {
        v: v || 1,
        req_id: req_id || '',
        hello_ok: {
          server_time_ms: Date.now(),
          changed_conversations: Array.from(conversations.entries()).map(([cid, data]) => ({
            conversation_id: cid,
            last_seq: data.lastSeq,
            unread_count: 0,
            last_message_preview: data.messages.length > 0 ? 'Preview' : '',
            last_message_at_ms: Date.now(),
          })),
        },
      };
      sendFrame(ws, helloOk);
      return;
    }

    // Ping / Pong
    if (body.ping) {
      sendFrame(ws, {
        v: v || 1,
        req_id: req_id || '',
        pong: { timestamp_ms: Date.now() },
      });
      return;
    }

    // SendMessage
    if (body.send) {
      const { message_id, conversation_id, kind, payload, reply_to_id, client_ts_ms } = body.send;
      const conv = getConversation(conversation_id);
      conv.lastSeq += 1;
      const seq = conv.lastSeq;
      const serverTs = Date.now();
      const senderInfo = clients.get(ws);
      const senderId = senderInfo ? senderInfo.userId : 'system';

      const newMsg = {
        conversation_id,
        seq,
        message_id,
        sender_id: senderId,
        kind: kind || 1,
        payload,
        reply_to_id,
        server_ts_ms: serverTs,
        edit_version: 0,
      };
      conv.messages.push(newMsg);

      console.log(`[fake-gateway] Message ${message_id} accepted: conv=${conversation_id} seq=${seq}`);

      // 1. Reply with Ack
      sendFrame(ws, {
        v: v || 1,
        req_id: req_id || '',
        ack: {
          message_id,
          seq,
          server_ts_ms: serverTs,
        },
      });

      // 2. Broadcast MessageNew to all sockets
      const messageNewFrame = {
        v: 1,
        message_new: newMsg,
      };

      for (const [clientWs] of clients.entries()) {
        sendFrame(clientWs, messageNewFrame);
      }
      return;
    }

    // ReceiptUpTo
    if (body.receipt) {
      const { conversation_id, delivered_upto_seq, read_upto_seq } = body.receipt;
      const senderInfo = clients.get(ws);
      const userId = senderInfo ? senderInfo.userId : 'unknown';

      console.log(`[fake-gateway] Receipt: conv=${conversation_id} user=${userId} del=${delivered_upto_seq} read=${read_upto_seq}`);

      const receiptUpdateFrame = {
        v: 1,
        receipt: {
          conversation_id,
          user_id: userId,
          delivered_upto_seq,
          read_upto_seq,
        },
      };

      for (const [clientWs] of clients.entries()) {
        sendFrame(clientWs, receiptUpdateFrame);
      }
      return;
    }

    // Typing
    if (body.typing) {
      const { conversation_id, is_typing } = body.typing;
      for (const [clientWs] of clients.entries()) {
        if (clientWs !== ws) {
          sendFrame(clientWs, {
            v: 1,
            typing: { conversation_id, is_typing },
          });
        }
      }
      return;
    }

    // SyncRequest
    if (body.sync) {
      const { conversation_id, after_seq, limit } = body.sync;
      const conv = getConversation(conversation_id);
      const filtered = conv.messages.filter((m) => m.seq > (after_seq || 0)).slice(0, limit || 50);

      sendFrame(ws, {
        v: v || 1,
        req_id: req_id || '',
        sync_batch: {
          conversation_id,
          messages: filtered,
          has_more: conv.messages.length > filtered.length,
        },
      });
      return;
    }
  });

  ws.on('close', () => {
    clients.delete(ws);
    console.log('[fake-gateway] Client disconnected. Remaining:', clients.size);
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`[fake-gateway] Listening on http/ws://0.0.0.0:${PORT}`);
});
