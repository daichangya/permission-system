package com.hiclaw.permission.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hiclaw.permission.common.PageResult;
import com.hiclaw.permission.common.Result;
import com.hiclaw.permission.dto.UserCreateRequest;
import com.hiclaw.permission.dto.UserResponse;
import com.hiclaw.permission.dto.UserUpdateRequest;
import com.hiclaw.permission.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 用户管理 Controller
 */
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /**
     * 分页查询用户
     */
    @GetMapping
    public Result<PageResult<UserResponse>> getUserPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) Long orgId,
            @RequestParam(required = false) Integer status) {
        
        Page<UserResponse> page = userService.getUserPage(pageNum, pageSize, username, email, orgId, status);
        PageResult<UserResponse> result = PageResult.of(
            page.getRecords(), 
            page.getTotal(), 
            pageNum, 
            pageSize
        );
        return Result.success(result);
    }

    /**
     * 查询用户详情
     */
    @GetMapping("/{id}")
    public Result<UserResponse> getUserById(@PathVariable Long id) {
        UserResponse user = userService.getUserById(id);
        return Result.success(user);
    }

    /**
     * 创建用户
     */
    @PostMapping
    public Result<UserResponse> createUser(@Valid @RequestBody UserCreateRequest request) {
        UserResponse user = userService.createUser(request);
        return Result.success(user);
    }

    /**
     * 更新用户
     */
    @PutMapping("/{id}")
    public Result<UserResponse> updateUser(
            @PathVariable Long id,
            @Valid @RequestBody UserUpdateRequest request) {
        UserResponse user = userService.updateUser(id, request);
        return Result.success(user);
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/{id}")
    public Result<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return Result.success();
    }

    /**
     * 批量删除用户
     */
    @DeleteMapping("/batch")
    public Result<Void> deleteUsers(@RequestBody List<Long> ids) {
        userService.deleteUsers(ids);
        return Result.success();
    }

    /**
     * 重置用户密码
     */
    @PutMapping("/{id}/password/reset")
    public Result<Void> resetPassword(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String password = body.get("password");
        userService.resetPassword(id, password);
        return Result.success();
    }

    /**
     * 检查用户名是否存在
     */
    @GetMapping("/check-username")
    public Result<Map<String, Boolean>> checkUsername(
            @RequestParam String username,
            @RequestParam(required = false) Long userId) {
        boolean exists = userService.checkUsername(username, userId);
        return Result.success(Map.of("exists", exists));
    }
}
