package com.hiclaw.permission.controller;

import com.hiclaw.permission.common.Result;
import com.hiclaw.permission.dto.LoginRequest;
import com.hiclaw.permission.dto.LoginResponse;
import com.hiclaw.permission.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 认证 Controller
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    /**
     * 用户登录
     */
    @PostMapping("/login")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse response = authService.login(request);
        return Result.success(response);
    }

    /**
     * 用户登出
     */
    @PostMapping("/logout")
    public Result<Void> logout() {
        // TODO: 可以将 token 加入黑名单
        return Result.success();
    }

    /**
     * 获取当前用户信息
     */
    @GetMapping("/me")
    public Result<LoginResponse.UserInfo> getCurrentUser(
            @RequestHeader("X-User-Id") Long userId) {
        LoginResponse.UserInfo userInfo = authService.getCurrentUser(userId);
        return Result.success(userInfo);
    }
}
