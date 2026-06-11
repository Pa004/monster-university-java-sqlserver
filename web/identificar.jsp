<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Monster University | Sistema de Matrículas</title>
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/bower_components/bootstrap/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/bower_components/font-awesome/css/font-awesome.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700&display=swap">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    
    body {
      font-family: 'Poppins', sans-serif;
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.42) 0%, rgba(118, 75, 162, 0.42) 100%),
                  url('${pageContext.request.contextPath}/images/Fondo01.jpg') center/cover no-repeat fixed;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
      position: relative;
      overflow: hidden;
    }
    
    body::before {
      content: '';
      position: absolute;
      width: 500px;
      height: 500px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 50%;
      top: -250px;
      right: -250px;
      animation: float 6s ease-in-out infinite;
    }
    
    body::after {
      content: '';
      position: absolute;
      width: 400px;
      height: 400px;
      background: rgba(255, 255, 255, 0.08);
      border-radius: 50%;
      bottom: -200px;
      left: -200px;
      animation: float 8s ease-in-out infinite reverse;
    }
    
    @keyframes float {
      0%, 100% { transform: translateY(0px); }
      50% { transform: translateY(20px); }
    }
    
    .login-container {
      background: white;
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      overflow: hidden;
      max-width: 900px;
      width: 100%;
      display: flex;
      position: relative;
      z-index: 1;
      animation: slideUp 0.6s ease-out;
    }
    
    @keyframes slideUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
    
    .login-left {
      flex: 1;
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.92) 0%, rgba(118, 75, 162, 0.92) 100%);
      padding: 60px 40px;
      color: white;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-align: center;
      position: relative;
      overflow: hidden;
    }
    
    .login-left::before {
      content: '🎓';
      position: absolute;
      font-size: 200px;
      opacity: 0.1;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
    }
    
    .login-left h1 {
      font-size: 32px;
      font-weight: 700;
      margin-bottom: 15px;
      position: relative;
    }
    
    .login-left p {
      font-size: 16px;
      opacity: 0.9;
      line-height: 1.6;
      position: relative;
    }
    
    .monster-logo {
      width: auto;
      height: auto;
      padding: 0;
      background: transparent;
      border-radius: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: none;
      margin-bottom: 18px;
      animation: floatLogo 6s ease-in-out infinite;
    }

    .monster-logo img {
      width: auto;
      height: 120px;
      object-fit: contain;
      border-radius: 0;
      box-shadow: none;
      background: transparent;
    }

    @keyframes floatLogo {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-6px); }
    }
    
    .login-right {
      flex: 1;
      padding: 60px 50px;
    }
    
    .login-header {
      text-align: center;
      margin-bottom: 40px;
    }
    
    .login-header h2 {
      font-size: 28px;
      font-weight: 600;
      color: #333;
      margin-bottom: 8px;
    }
    
    .login-header p {
      color: #666;
      font-size: 14px;
    }
    
    .form-group {
      margin-bottom: 25px;
      position: relative;
    }
    
    .form-group label {
      display: block;
      font-size: 14px;
      font-weight: 500;
      color: #555;
      margin-bottom: 8px;
    }
    
    .input-wrapper {
      position: relative;
    }
    
    .input-wrapper i {
      position: absolute;
      left: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: #999;
      font-size: 18px;
    }
    
    .form-control {
      width: 100%;
      padding: 14px 15px 14px 45px;
      border: 2px solid #e0e0e0;
      border-radius: 10px;
      font-size: 14px;
      transition: all 0.3s ease;
      background: #f8f9fa;
    }
    
    .form-control:focus {
      outline: none;
      border-color: #667eea;
      background: white;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
    
    .remember-forgot {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 25px;
      font-size: 14px;
    }
    
    .remember-forgot label {
      display: flex;
      align-items: center;
      color: #666;
      cursor: pointer;
    }
    
    .remember-forgot input[type="checkbox"] {
      margin-right: 8px;
    }
    
    .remember-forgot a {
      color: #667eea;
      text-decoration: none;
      font-weight: 500;
    }
    
    .remember-forgot a:hover {
      text-decoration: underline;
    }
    
    .btn-login {
      width: 100%;
      padding: 14px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 10px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    
    .btn-login:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
    }
    
    .btn-login:active {
      transform: translateY(0);
    }
    
    .alert {
      padding: 12px 15px;
      border-radius: 10px;
      margin-bottom: 20px;
      font-size: 14px;
      animation: slideDown 0.4s ease-out;
    }
    
    @keyframes slideDown {
      from {
        opacity: 0;
        transform: translateY(-10px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
    
    .alert-danger {
      background: #fee;
      color: #c33;
      border: 1px solid #fcc;
    }
    
    .alert-success {
      background: #efe;
      color: #3c3;
      border: 1px solid #cfc;
    }
    
    .footer-text {
      text-align: center;
      margin-top: 30px;
      color: #999;
      font-size: 13px;
    }
    
    @media (max-width: 768px) {
      .login-container {
        flex-direction: column;
      }
      
      .login-left {
        padding: 40px 30px;
      }
      
      .login-right {
        padding: 40px 30px;
      }
      
      .login-left h1 {
        font-size: 26px;
      }
    }
  </style>
</head>
<body>
  <div class="login-container">
    <!-- Lado Izquierdo: Branding -->
    <div class="login-left">
      <div class="monster-logo">
        <img src="${pageContext.request.contextPath}/images/logo01.png" alt="Monster University">
      </div>
      <h1>Monster University</h1>
      <p>Sistema de Gestión de Matrículas</p>
      <p style="margin-top: 20px; font-size: 14px;">Bienvenido al portal académico. Ingresa tus credenciales para acceder al sistema.</p>
    </div>
    
    <!-- Lado Derecho: Formulario -->
    <div class="login-right">
      <div class="login-header">
        <h2>Iniciar Sesión</h2>
        <p>Ingresa tu usuario y contraseña</p>
      </div>
      
      <!-- Mensajes de error/éxito -->
      <c:if test="${not empty mensaje}">
        <div class="alert alert-${tipoMensaje == 'error' ? 'danger' : 'success'}">
          <i class="fa fa-${tipoMensaje == 'error' ? 'exclamation-circle' : 'check-circle'}"></i>
          ${mensaje}
        </div>
      </c:if>
      
      <!-- Formulario de Login -->
      <form action="${pageContext.request.contextPath}/srvUsuario" method="POST">
        <input type="hidden" name="accion" value="verificar">
        
        <div class="form-group">
          <label>Usuario</label>
          <div class="input-wrapper">
            <i class="fa fa-user"></i>
            <input type="text" name="txtUsu" id="txtUsu" value="${username}" 
                   class="form-control" placeholder="Ingresa tu usuario" required autofocus>
          </div>
        </div>
        
        <div class="form-group">
          <label>Contraseña</label>
          <div class="input-wrapper">
            <i class="fa fa-lock"></i>
            <input type="password" name="txtPass" id="txtPass" 
                   class="form-control" placeholder="Ingresa tu contraseña" required>
          </div>
        </div>
        
        <div class="remember-forgot">
          <label>
            <input type="checkbox" name="remember">
            <span>Recuérdame</span>
          </label>
          <a href="recuperarContrasena.jsp">¿Olvidaste tu contraseña?</a>
        </div>
        
        <button type="submit" class="btn-login">
          <i class="fa fa-sign-in"></i> Ingresar al Sistema
        </button>
      </form>
      
      <div class="footer-text">
        © 2024 Monster University. Todos los derechos reservados.
      </div>
    </div>
  </div>

  <script src="${pageContext.request.contextPath}/bower_components/jquery/dist/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
</body>
</html>

