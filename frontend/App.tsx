/**
 * 应用入口组件
 * 配置路由和权限守卫
 */

import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { useUserStore } from '@/store/user'

// 布局组件
import BasicLayout from '@/layouts/BasicLayout'
import UserLayout from '@/layouts/UserLayout'

// 页面组件
import Login from '@/pages/Login'
import UserList from '@/pages/User/List'

// 登录页路由（无需认证）
function UserLayoutWrapper() {
  return (
    <UserLayout>
      <Login />
    </UserLayout>
  )
}

// 需要认证的路由守卫
function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const isAuthenticated = useUserStore((state) => state.isAuthenticated)
  
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />
  }
  
  return <BasicLayout>{children}</BasicLayout>
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* 公开路由 */}
        <Route path="/login" element={<UserLayoutWrapper />} />
        
        {/* 需要认证的路由 */}
        <Route
          path="/"
          element={
            <ProtectedRoute>
              <div />
            </ProtectedRoute>
          }
        >
          <Route index element={<Navigate to="/user" replace />} />
          <Route path="user" element={<UserList />} />
        </Route>
        
        {/* 404 */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
