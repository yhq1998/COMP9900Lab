#!/bin/bash

# 设置API基础URL
BASE_URL="http://localhost:8080"

# 测试用户注册
echo "\n测试用户注册..."
curl -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser1","fullName":"Test User","email":"test@example.com","phoneNumber":"1234567890","password":"password123"}'

# 测试用户登录
echo "\n\n测试用户登录..."
LOGIN_RESPONSE=$(curl -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser1","password":"password123"}')

echo "$LOGIN_RESPONSE"

# 测试获取所有用户
echo "\n\n测试获取所有用户..."
curl -X GET "$BASE_URL/users"

# 测试创建订单
echo "\n\n测试创建订单..."
ORDER_RESPONSE=$(curl -X POST "$BASE_URL/orders" \
  -H "Content-Type: application/json" \
  -d '{"orderNumber":"ORD-001","userId":1,"startLocation":"Sydney CBD","endLocation":"Bondi Beach","estimatedTime":30,"fare":25.50,"passengerCount":2,"luggageInfo":"2 bags","status":"PENDING"}')

echo "$ORDER_RESPONSE"

# 从响应中提取订单ID（假设响应中包含订单ID）
ORDER_ID=$(echo $ORDER_RESPONSE | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)

# 测试获取所有订单
echo "\n\n测试获取所有订单..."
curl -X GET "$BASE_URL/orders"

# 如果成功获取到订单ID，则测试更新和删除
if [ ! -z "$ORDER_ID" ]; then
  # 测试更新订单
  echo "\n\n测试更新订单 ID: $ORDER_ID..."
  curl -X PUT "$BASE_URL/orders/$ORDER_ID" \
    -H "Content-Type: application/json" \
    -d '{"id":"'$ORDER_ID'","fare":30.00,"status":"CONFIRMED"}'

  # 测试获取特定订单
  echo "\n\n测试获取特定订单 ID: $ORDER_ID..."
  curl -X GET "$BASE_URL/orders/$ORDER_ID"

  # 测试删除订单
  echo "\n\n测试删除订单 ID: $ORDER_ID..."
  curl -X DELETE "$BASE_URL/orders/$ORDER_ID"
fi

echo "\n\n测试完成！"