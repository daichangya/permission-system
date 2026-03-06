package com.hiclaw.permission.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hiclaw.permission.dto.UserCreateRequest;
import com.hiclaw.permission.dto.UserResponse;
import com.hiclaw.permission.dto.UserUpdateRequest;
import com.hiclaw.permission.entity.SysUser;

import java.util.List;

/**
 * 用户服务接口
 */
public interface UserService {

    /**
     * 分页查询用户
     */
    com.baomidou.mybatisplus.extension.plugins.pagination.Page<UserResponse> getUserPage(Integer pageNum, Integer pageSize, String username, String email, Long orgId, Integer status);

    /**
     * 根据 ID 查询用户详情
     */
    UserResponse getUserById(Long id);

    /**
     * 创建用户
     */
    UserResponse createUser(UserCreateRequest request);

    /**
     * 更新用户
     */
    UserResponse updateUser(Long id, UserUpdateRequest request);

    /**
     * 删除用户
     */
    void deleteUser(Long id);

    /**
     * 批量删除用户
     */
    void deleteUsers(List<Long> ids);

    /**
     * 重置用户密码
     */
    void resetPassword(Long id, String password);

    /**
     * 检查用户名是否存在
     */
    boolean checkUsername(String username, Long excludeId);

    /**
     * 根据用户名查询用户
     */
    SysUser getByUsername(String username);
}
