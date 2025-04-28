import Cookies from 'js-cookie'
import { mockRefreshToken, parseJwt } from './mockRefreshToken'

const TokenKey = 'Admin-Token'

export function getToken() {
  const token = Cookies.get(TokenKey)
  console.log('Get Token:', token ? token.substring(0, 15) + '...' : 'null')
  return token
}

export function setToken(token) {
  if (!token) {
    console.error('Set Token failed: token is empty')
    return false
  }
  
  try {
    console.log('Set Token:', token.substring(0, 15) + '...')
    // Check if the token is a valid JWT format
    const payload = parseJwt(token)
    if (!payload) {
      console.error('Set Token failed: Invalid token format')
      return false
    }
    
    // Get token expiration time and set cookie expiration time
    let expires = 1 // Default 1 day
    if (payload.exp) {
      const expireDate = new Date(payload.exp * 1000)
      expires = (expireDate - new Date()) / (1000 * 60 * 60 * 24) // Convert to days
      console.log('Token will expire at:', expireDate.toLocaleString(), '(', Math.round(expires * 24), 'hours)')
    }
    
    Cookies.set(TokenKey, token, { expires: expires > 0 ? expires : 1 })
    return true
  } catch (error) {
    console.error('Error occurred while setting token:', error)
    return false
  }
}

export function removeToken() {
  console.log('Remove Token')
  return Cookies.remove(TokenKey)
}

// Check if Token is expired
export function isTokenExpired() {
  const token = getToken()
  if (!token) {
    console.warn('Check token expiration: No token')
    return true
  }
  
  const payload = parseJwt(token)
  if (!payload || !payload.exp) {
    console.error('Check token expiration: Unable to parse token or token has no expiration time')
    return true
  }
  
  const now = Math.floor(Date.now() / 1000)
  const isExpired = now >= payload.exp
  
  if (isExpired) {
    console.warn('Token expired, expiration time:', new Date(payload.exp * 1000).toLocaleString())
  } else {
    const remainingTime = payload.exp - now
    console.log('Token valid, remaining time:', Math.floor(remainingTime / 60), 'minutes')
  }
  
  return isExpired
}

// Refresh Token
export async function refreshToken() {
  console.log('Attempt to refresh Token')
  try {
    const oldToken = getToken()
    if (!oldToken) {
      console.error('Refresh Token failed: No existing Token')
      return false
    }
    
    // Check if the current token is actually needed to be refreshed
    const payload = parseJwt(oldToken)
    if (payload && payload.exp) {
      const now = Math.floor(Date.now() / 1000)
      // If the token has more than 30 minutes of effective period, no need to refresh
      if (payload.exp - now > 30 * 60) {
        console.log('Token still valid, no need to refresh, remaining:', Math.floor((payload.exp - now) / 60), 'minutes')
        return true
      }
    }
    
    console.log('Start refreshing Token:', oldToken.substring(0, 15) + '...')
    const response = await mockRefreshToken(oldToken)
    console.log('Refresh Token response:', response)
    
    if (response.code === 200 && response.token) {
      const result = setToken(response.token)
      if (result) {
        console.log('Token refresh successful')
        return true
      } else {
        console.error('Token refresh save failed')
        return false
      }
    } else {
      console.error('Token refresh failed, response code:', response.code, ', message:', response.message)
      return false
    }
  } catch (error) {
    console.error('Exception occurred during Token refresh:', error)
    return false
  }
}

// Get Token expiration time (milliseconds timestamp)
export function getTokenExpireTime() {
  const token = getToken()
  if (!token) return null
  
  const payload = parseJwt(token)
  if (!payload || !payload.exp) return null
  
  return payload.exp * 1000
}

// Get user information from Token
export function getTokenUserInfo() {
  const token = getToken()
  if (!token) return null
  
  const payload = parseJwt(token)
  if (!payload) return null
  
  // Return user information based on actual token format
  return {
    userId: payload.userId || payload.sub || null,
    username: payload.username || null,
    roles: payload.roles || [],
    // Other possible user information fields
  }
} 