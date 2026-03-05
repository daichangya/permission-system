-- =====================================================
-- 通用权限管理系统 - 数据库初始化脚本
-- =====================================================
-- Database: permission_system
-- Charset: utf8mb4
-- Engine: InnoDB
-- =====================================================

CREATE DATABASE IF NOT EXISTS `permission_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `permission_system`;

-- =====================================================
-- 1. 组织表
-- =====================================================
DROP TABLE IF EXISTS `sys_org`;
CREATE TABLE `sys_org` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `name` VARCHAR(128) NOT NULL COMMENT '组织名称',
  `code` VARCHAR(64) NOT NULL COMMENT '组织编码',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父组织 ID（0=顶级）',
  `type` TINYINT DEFAULT 1 COMMENT '类型 1=公司 2=部门 3=小组',
  `leader_id` BIGINT DEFAULT NULL COMMENT '负责人 ID',
  `sort_order` INT DEFAULT 0 COMMENT '排序号',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `is_deleted` TINYINT DEFAULT 0 COMMENT '删除标记',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='组织表';

-- =====================================================
-- 2. 用户表
-- =====================================================
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `username` VARCHAR(64) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '加密密码',
  `email` VARCHAR(128) DEFAULT NULL COMMENT '邮箱',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `nickname` VARCHAR(64) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像 URL',
  `gender` TINYINT DEFAULT 0 COMMENT '性别 0=未知 1=男 2=女',
  `org_id` BIGINT DEFAULT NULL COMMENT '所属组织 ID',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `is_deleted` TINYINT DEFAULT 0 COMMENT '删除标记',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_org_id` (`org_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- =====================================================
-- 3. 用户组织关联表
-- =====================================================
DROP TABLE IF EXISTS `sys_user_org`;
CREATE TABLE `sys_user_org` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `user_id` BIGINT NOT NULL COMMENT '用户 ID',
  `org_id` BIGINT NOT NULL COMMENT '组织 ID',
  `is_primary` TINYINT DEFAULT 0 COMMENT '是否主组织 0=否 1=是',
  `joined_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_org` (`user_id`, `org_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_org_id` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户组织关联表';

-- =====================================================
-- 4. 角色表
-- =====================================================
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `name` VARCHAR(64) NOT NULL COMMENT '角色名称',
  `code` VARCHAR(64) NOT NULL COMMENT '角色编码',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '描述',
  `sort_order` INT DEFAULT 0 COMMENT '排序号',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `is_deleted` TINYINT DEFAULT 0 COMMENT '删除标记',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- =====================================================
-- 5. 用户角色关联表
-- =====================================================
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `user_id` BIGINT NOT NULL COMMENT '用户 ID',
  `role_id` BIGINT NOT NULL COMMENT '角色 ID',
  `assigned_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`, `role_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- =====================================================
-- 6. 权限表
-- =====================================================
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `name` VARCHAR(64) NOT NULL COMMENT '权限名称',
  `code` VARCHAR(128) NOT NULL COMMENT '权限编码',
  `type` TINYINT DEFAULT 1 COMMENT '类型 1=菜单 2=按钮 3=API',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父权限 ID（0=顶级）',
  `path` VARCHAR(255) DEFAULT NULL COMMENT '资源路径',
  `method` VARCHAR(10) DEFAULT NULL COMMENT 'HTTP 方法',
  `sort_order` INT DEFAULT 0 COMMENT '排序号',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `is_deleted` TINYINT DEFAULT 0 COMMENT '删除标记',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';

-- =====================================================
-- 7. 角色权限关联表
-- =====================================================
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `role_id` BIGINT NOT NULL COMMENT '角色 ID',
  `permission_id` BIGINT NOT NULL COMMENT '权限 ID',
  `assigned_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_perm` (`role_id`, `permission_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

-- =====================================================
-- 8. 数据范围表
-- =====================================================
DROP TABLE IF EXISTS `sys_data_scope`;
CREATE TABLE `sys_data_scope` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `name` VARCHAR(64) NOT NULL COMMENT '范围名称',
  `code` VARCHAR(64) NOT NULL COMMENT '范围编码',
  `scope_type` TINYINT NOT NULL COMMENT '范围类型 1=全部 2=本部门 3=本部门及子部门 4=本人 5=自定义',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '描述',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_scope_type` (`scope_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据范围表';

-- =====================================================
-- 9. 角色数据范围关联表
-- =====================================================
DROP TABLE IF EXISTS `sys_role_data_scope`;
CREATE TABLE `sys_role_data_scope` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `role_id` BIGINT NOT NULL COMMENT '角色 ID',
  `data_scope_id` BIGINT NOT NULL COMMENT '数据范围 ID',
  `custom_org_ids` VARCHAR(512) DEFAULT NULL COMMENT '自定义组织 ID 列表（JSON 数组）',
  `assigned_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_scope` (`role_id`, `data_scope_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_data_scope_id` (`data_scope_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色数据范围关联表';

-- =====================================================
-- 10. 菜单表
-- =====================================================
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `name` VARCHAR(64) NOT NULL COMMENT '菜单名称',
  `path` VARCHAR(255) DEFAULT NULL COMMENT '路由路径',
  `component` VARCHAR(255) DEFAULT NULL COMMENT '前端组件路径',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父菜单 ID（0=顶级）',
  `icon` VARCHAR(64) DEFAULT NULL COMMENT '图标',
  `sort_order` INT DEFAULT 0 COMMENT '排序号',
  `is_visible` TINYINT DEFAULT 1 COMMENT '是否可见 0=否 1=是',
  `is_cache` TINYINT DEFAULT 1 COMMENT '是否缓存 0=否 1=是',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `is_deleted` TINYINT DEFAULT 0 COMMENT '删除标记',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单表';

-- =====================================================
-- 11. 角色菜单关联表
-- =====================================================
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `role_id` BIGINT NOT NULL COMMENT '角色 ID',
  `menu_id` BIGINT NOT NULL COMMENT '菜单 ID',
  `assigned_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_menu` (`role_id`, `menu_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色菜单关联表';

-- =====================================================
-- 12. 操作日志表
-- =====================================================
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户 ID',
  `username` VARCHAR(64) DEFAULT NULL COMMENT '用户名',
  `module` VARCHAR(64) DEFAULT NULL COMMENT '模块名称',
  `operation` VARCHAR(128) DEFAULT NULL COMMENT '操作名称',
  `method` VARCHAR(255) DEFAULT NULL COMMENT '请求方法',
  `request_url` VARCHAR(512) DEFAULT NULL COMMENT '请求 URL',
  `request_params` TEXT DEFAULT NULL COMMENT '请求参数（JSON）',
  `response_data` TEXT DEFAULT NULL COMMENT '响应数据（JSON）',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=失败 1=成功',
  `error_msg` TEXT DEFAULT NULL COMMENT '错误信息',
  `ip_address` VARCHAR(64) DEFAULT NULL COMMENT 'IP 地址',
  `ip_location` VARCHAR(255) DEFAULT NULL COMMENT 'IP 归属地',
  `cost_time` BIGINT DEFAULT 0 COMMENT '耗时（毫秒）',
  `oper_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_oper_time` (`oper_time`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- =====================================================
-- 13. 登录日志表
-- =====================================================
DROP TABLE IF EXISTS `sys_login_log`;
CREATE TABLE `sys_login_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户 ID',
  `username` VARCHAR(64) DEFAULT NULL COMMENT '用户名',
  `login_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
  `ip_address` VARCHAR(64) DEFAULT NULL COMMENT 'IP 地址',
  `ip_location` VARCHAR(255) DEFAULT NULL COMMENT 'IP 归属地',
  `browser` VARCHAR(128) DEFAULT NULL COMMENT '浏览器',
  `os` VARCHAR(64) DEFAULT NULL COMMENT '操作系统',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=失败 1=成功',
  `error_msg` VARCHAR(512) DEFAULT NULL COMMENT '错误信息',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_login_time` (`login_time`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='登录日志表';

-- =====================================================
-- 初始化数据
-- =====================================================

-- 默认组织
INSERT INTO `sys_org` (`id`, `name`, `code`, `parent_id`, `type`, `sort_order`) VALUES
(1, '总公司', 'HQ', 0, 1, 1),
(2, '技术部', 'TECH', 1, 2, 1),
(3, '产品部', 'PROD', 1, 2, 2),
(4, '研发一组', 'DEV1', 2, 3, 1),
(5, '研发二组', 'DEV2', 2, 3, 2);

-- 默认角色
INSERT INTO `sys_role` (`id`, `name`, `code`, `description`, `sort_order`) VALUES
(1, '超级管理员', 'SUPER_ADMIN', '系统最高权限角色', 1),
(2, '系统管理员', 'ADMIN', '系统管理权限', 2),
(3, '部门经理', 'DEPT_MANAGER', '部门管理权限', 3),
(4, '普通员工', 'EMPLOYEE', '普通员工权限', 4);

-- 默认用户（密码：admin123，BCrypt 加密）
INSERT INTO `sys_user` (`id`, `username`, `password`, `email`, `nickname`, `org_id`, `status`) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lqkkO9QS3TzCjH3rS', 'admin@example.com', '超级管理员', 1, 1),
(2, 'user1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lqkkO9QS3TzCjH3rS', 'user1@example.com', '测试用户 1', 2, 1);

-- 用户角色关联
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 4);

-- 用户组织关联
INSERT INTO `sys_user_org` (`user_id`, `org_id`, `is_primary`) VALUES
(1, 1, 1),
(2, 2, 1);

-- 数据范围
INSERT INTO `sys_data_scope` (`id`, `name`, `code`, `scope_type`, `description`) VALUES
(1, '全部数据', 'ALL', 1, '可查看所有数据'),
(2, '本部门数据', 'DEPT', 2, '仅查看本部门数据'),
(3, '本部门及子部门数据', 'DEPT_AND_CHILD', 3, '查看本部门及下级部门数据'),
(4, '仅本人数据', 'SELF', 4, '仅查看本人数据'),
(5, '自定义数据', 'CUSTOM', 5, '自定义数据范围');

-- 角色数据范围关联
INSERT INTO `sys_role_data_scope` (`role_id`, `data_scope_id`) VALUES
(1, 1),
(2, 1),
(3, 3),
(4, 4);

-- 默认权限
INSERT INTO `sys_permission` (`id`, `name`, `code`, `type`, `parent_id`, `path`, `method`, `sort_order`) VALUES
-- 系统管理模块
(1, '系统管理', 'system', 1, 0, NULL, NULL, 1),
(2, '用户管理', 'system:user', 1, 1, '/system/user', NULL, 1),
(3, '用户查询', 'system:user:query', 3, 2, '/api/users', 'GET', 1),
(4, '用户新增', 'system:user:add', 3, 2, '/api/users', 'POST', 2),
(5, '用户修改', 'system:user:edit', 3, 2, '/api/users/*', 'PUT', 3),
(6, '用户删除', 'system:user:delete', 3, 2, '/api/users/*', 'DELETE', 4),
(7, '角色管理', 'system:role', 1, 1, '/system/role', NULL, 2),
(8, '角色查询', 'system:role:query', 3, 7, '/api/roles', 'GET', 1),
(9, '角色新增', 'system:role:add', 3, 7, '/api/roles', 'POST', 2),
(10, '角色修改', 'system:role:edit', 3, 7, '/api/roles/*', 'PUT', 3),
(11, '角色删除', 'system:role:delete', 3, 7, '/api/roles/*', 'DELETE', 4),
(12, '组织管理', 'system:org', 1, 1, '/system/org', NULL, 3),
(13, '组织查询', 'system:org:query', 3, 12, '/api/orgs', 'GET', 1),
(14, '组织新增', 'system:org:add', 3, 12, '/api/orgs', 'POST', 2),
(15, '组织修改', 'system:org:edit', 3, 12, '/api/orgs/*', 'PUT', 3),
(16, '组织删除', 'system:org:delete', 3, 12, '/api/orgs/*', 'DELETE', 4);

-- 角色权限关联（超级管理员拥有所有权限）
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`)
SELECT 1, id FROM `sys_permission`;

-- 默认菜单
INSERT INTO `sys_menu` (`id`, `name`, `path`, `component`, `parent_id`, `icon`, `sort_order`, `is_visible`, `is_cache`) VALUES
(1, '系统管理', '/system', 'Layout', 0, 'setting', 1, 1, 1),
(2, '用户管理', '/system/user', 'system/user/index', 1, 'user', 1, 1, 1),
(3, '角色管理', '/system/role', 'system/role/index', 1, 'peoples', 2, 1, 1),
(4, '组织管理', '/system/org', 'system/org/index', 1, 'tree-table', 3, 1, 1),
(5, '操作日志', '/system/oper-log', 'system/oper-log/index', 1, 'documentation', 4, 1, 1),
(6, '登录日志', '/system/login-log', 'system/login-log/index', 1, 'login', 5, 1, 1);

-- 角色菜单关联（超级管理员拥有所有菜单）
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, id FROM `sys_menu`;

-- =====================================================
-- 脚本结束
-- =====================================================
