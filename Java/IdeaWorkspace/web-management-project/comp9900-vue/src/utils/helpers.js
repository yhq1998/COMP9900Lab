/**
 * Utility function library
 * Provides commonly used helper functions
 */

/**
 * Format date
 * @param {Date|string|number} date Date object, timestamp or date string
 * @param {string} format Format pattern, defaults to 'YYYY-MM-DD HH:mm:ss'
 * @returns {string} Formatted date string
 */
export function formatDate(date, format = 'YYYY-MM-DD HH:mm:ss') {
  if (!date) return '';
  
  const d = new Date(date);
  if (isNaN(d.getTime())) return '';
  
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  const hours = String(d.getHours()).padStart(2, '0');
  const minutes = String(d.getMinutes()).padStart(2, '0');
  const seconds = String(d.getSeconds()).padStart(2, '0');
  
  return format
    .replace('YYYY', year)
    .replace('MM', month)
    .replace('DD', day)
    .replace('HH', hours)
    .replace('mm', minutes)
    .replace('ss', seconds);
}

/**
 * Deep copy object
 * @param {Object} obj Object to copy
 * @returns {Object} New copied object
 */
export function deepClone(obj) {
  if (obj === null || typeof obj !== 'object') return obj;
  
  if (obj instanceof Date) return new Date(obj);
  if (obj instanceof Array) return obj.map(item => deepClone(item));
  
  const clonedObj = {};
  for (const key in obj) {
    if (Object.prototype.hasOwnProperty.call(obj, key)) {
      clonedObj[key] = deepClone(obj[key]);
    }
  }
  
  return clonedObj;
}

/**
 * Debounce function
 * @param {Function} fn Function to execute
 * @param {number} delay Delay time, in milliseconds
 * @returns {Function} Debounced function
 */
export function debounce(fn, delay = 300) {
  let timer = null;
  return function(...args) {
    if (timer) clearTimeout(timer);
    timer = setTimeout(() => {
      fn.apply(this, args);
    }, delay);
  };
}

/**
 * Throttle function
 * @param {Function} fn Function to execute
 * @param {number} limit Limit time, in milliseconds
 * @returns {Function} Throttled function
 */
export function throttle(fn, limit = 300) {
  let inThrottle = false;
  return function(...args) {
    if (!inThrottle) {
      fn.apply(this, args);
      inThrottle = true;
      setTimeout(() => {
        inThrottle = false;
      }, limit);
    }
  };
}

/**
 * Generate unique ID
 * @returns {string} Unique ID
 */
export function generateUniqueId() {
  return Date.now().toString(36) + Math.random().toString(36).substr(2, 5);
}

/**
 * Format currency
 * @param {number} amount Amount
 * @param {number} decimals Decimal places
 * @param {string} currency Currency symbol
 * @returns {string} Formatted amount
 */
export function formatCurrency(amount, decimals = 2, currency = '$') {
  if (isNaN(amount)) return '';
  
  const formatter = new Intl.NumberFormat('zh-CN', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals
  });
  
  return `${currency} ${formatter.format(amount)}`;
}

/**
 * Get file extension
 * @param {string} filename File name
 * @returns {string} File extension
 */
export function getFileExtension(filename) {
  return filename.slice((filename.lastIndexOf('.') - 1 >>> 0) + 2);
}

/**
 * Validate email format
 * @param {string} email Email address
 * @returns {boolean} Whether it is a valid email
 */
export function validateEmail(email) {
  const re = /^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/;
  return re.test(email);
}

/**
 * Validate phone number format
 * @param {string} phone Phone number
 * @returns {boolean} Whether it is a valid phone number
 */
export function validatePhone(phone) {
  const re = /^1[3-9]\d{9}$/;
  return re.test(phone);
}

/**
 * Get browser local storage data
 * @param {string} key Storage key name
 * @param {boolean} useSession Whether to use sessionStorage, defaults to localStorage
 * @returns {any} Stored data
 */
export function getStorageItem(key, useSession = false) {
  const storage = useSession ? sessionStorage : localStorage;
  const value = storage.getItem(key);
  try {
    return JSON.parse(value);
  } catch (e) {
    return value;
  }
}

/**
 * Set browser local storage data
 * @param {string} key Storage key name
 * @param {any} value Data to store
 * @param {boolean} useSession Whether to use sessionStorage, defaults to localStorage
 */
export function setStorageItem(key, value, useSession = false) {
  const storage = useSession ? sessionStorage : localStorage;
  if (typeof value === 'object') {
    storage.setItem(key, JSON.stringify(value));
  } else {
    storage.setItem(key, value);
  }
}

/**
 * Remove browser local storage data
 * @param {string} key Storage key name
 * @param {boolean} useSession Whether to use sessionStorage, defaults to localStorage
 */
export function removeStorageItem(key, useSession = false) {
  const storage = useSession ? sessionStorage : localStorage;
  storage.removeItem(key);
}