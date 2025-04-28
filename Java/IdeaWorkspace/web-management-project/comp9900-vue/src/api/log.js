import request from '@/utils/request'

//分页条件查询
export const queryPageApi = (page, pageSize) => request.get(`/auth/logs/page?page=${page}&pageSize=${pageSize}`)
