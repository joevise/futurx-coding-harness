# Event: {event-name}

> 模板。复制成 `<event-name>.md` 后填写。

## 元信息
- **事件名**：
- **生产者**：
- **消费者**：
- **传输**：Kafka / RabbitMQ / SNS / ...

## Schema
```json
{
  "type": "object",
  "properties": {
    "eventId": {"type": "string"},
    "occurredAt": {"type": "string", "format": "date-time"},
    "payload": {"type": "object"}
  },
  "required": ["eventId", "occurredAt", "payload"]
}
```

## 示例
```json
{
  "eventId": "evt_xxx",
  "occurredAt": "2026-05-21T10:00:00Z",
  "payload": {}
}
```

**关联**：US-XXX / PRD §X.Y
