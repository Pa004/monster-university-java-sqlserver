<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Monster University | Recuperar Contraseña</title>
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
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
      position: relative;
      overflow-y: auto;
      overflow-x: hidden;
      background-attachment: fixed;
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
    
    .recovery-container {
      background: white;
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      overflow: hidden;
      max-width: 520px;
      width: 95%;
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
    
    .recovery-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      padding: 35px 35px;
      color: white;
      text-align: center;
      position: relative;
    }
    
    .recovery-header::before {
      content: '🔐';
      display: block;
      font-size: 55px;
      margin-bottom: 12px;
    }
    
    .recovery-header h1 {
      font-size: 26px;
      font-weight: 700;
      margin-bottom: 8px;
    }
    
    .recovery-header p {
      font-size: 13px;
      opacity: 0.95;
      margin: 0;
    }
    
    .recovery-body {
      padding: 32px 35px;
    }
    
    .form-group {
      margin-bottom: 22px;
    }
    
    .form-group label {
      font-weight: 600;
      color: #333;
      margin-bottom: 8px;
      display: block;
      font-size: 14px;
    }
    
    .input-wrapper {
      position: relative;
      display: flex;
      align-items: center;
    }
    
    .input-wrapper i {
      position: absolute;
      left: 15px;
      color: #667eea;
      font-size: 15px;
    }
    
    .form-control {
      padding-left: 45px !important;
      height: 48px;
      border: 2px solid #e0e0e0;
      border-radius: 10px;
      font-size: 14px;
      transition: all 0.3s ease;
    }
    
    .form-control:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
      outline: none;
    }
    
    .btn-recovery {
      width: 100%;
      height: 48px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 10px;
      font-weight: 600;
      font-size: 16px;
      cursor: pointer;
      transition: all 0.3s ease;
      margin-top: 8px;
    }
    
    .btn-recovery:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
    }
    
    .btn-recovery:active {
      transform: translateY(0);
    }
    
    .btn-back {
      width: 100%;
      height: 48px;
      background: #f0f0f0;
      color: #667eea;
      border: none;
      border-radius: 10px;
      font-weight: 600;
      font-size: 16px;
      cursor: pointer;
      transition: all 0.3s ease;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .btn-back:hover {
      background: #e0e0e0;
    }
    
    .alert {
      border-radius: 10px;
      border: none;
      margin-bottom: 20px;
      font-size: 14px;
    }
    
    .alert-info {
      background: #e3f2fd;
      color: #1565c0;
    }
    
    .alert-success {
      background: #e8f5e9;
      color: #2e7d32;
    }
    
    .alert-danger {
      background: #ffebee;
      color: #c62828;
    }
    
    .help-text {
      font-size: 11px;
      color: #999;
      margin-top: 5px;
    }
    
    .steps {
      background: #f9f9f9;
      padding: 18px;
      border-radius: 10px;
      margin-bottom: 22px;
    }
    
    .steps h4 {
      font-weight: 600;
      color: #333;
      font-size: 14px;
      margin-bottom: 10px;
    }
    
    .steps ol {
      margin: 0;
      padding-left: 20px;
    }
    
    .steps li {
      font-size: 13px;
      color: #666;
      margin-bottom: 5px;
    }
  </style>
</head>
<body>
  <div class="recovery-container">
    <div class="recovery-header">
      <h1>Recuperar Contraseña</h1>
      <p>Te ayudaremos a restaurar el acceso a tu cuenta</p>
    </div>
    
    <div class="recovery-body">
      <!-- Mensajes de estado -->
      <c:if test="${not empty mensaje}">
        <div class="alert alert-${tipoMensaje}">
          <i class="fa fa-${tipoMensaje == 'success' ? 'check-circle' : 'info-circle'}"></i>
          ${mensaje}
        </div>
      </c:if>
      
      <c:if test="${not empty error}">
        <div class="alert alert-danger">
          <i class="fa fa-exclamation-circle"></i>
          ${error}
        </div>
      </c:if>
      
      <!-- Pasos a seguir -->
      <div class="steps">
        <h4><i class="fa fa-info-circle"></i> ¿Cómo funciona?</h4>
        <ol>
          <li>Ingresa tu usuario o correo electrónico</li>
          <li>Te enviaremos tu contraseña al correo registrado</li>
          <li>Copia la contraseña y accede al sistema</li>
        </ol>
      </div>
      
      <form method="POST" action="srvRecuperarContrasena" id="frmRecuperacion">
        <div class="form-group">
          <label>Usuario o Correo Electrónico <span style="color: #e63757;">*</span></label>
          <div class="input-wrapper">
            <i class="fa fa-user"></i>
            <input type="text" name="usuarioOCorreo" class="form-control" 
                   placeholder="Ingresa tu usuario o correo" required autofocus>
          </div>
          <div class="help-text">
            <i class="fa fa-lightbulb-o"></i> Ingresa el usuario con el que te registraste o tu correo institucional
          </div>
        </div>
        
        <button type="submit" class="btn-recovery">
          <i class="fa fa-envelope"></i> Enviar Contraseña
        </button>
      </form>
      
      <div style="margin-top: 15px;">
        <a href="identificar.jsp" class="btn-back">
          <i class="fa fa-arrow-left"></i> Volver al Login
        </a>
      </div>
      
      <!-- Información de seguridad -->
      <div class="alert alert-info" style="margin-top: 15px; margin-bottom: 0; font-size: 12px;">
        <i class="fa fa-shield"></i> <strong>Seguridad:</strong> 
        Tu contraseña se envía de forma segura a tu correo registrado.
      </div>
    </div>
  </div>

  <script src="${pageContext.request.contextPath}/bower_components/jquery/dist/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
  <script>
    // Validación antes de enviar
    document.getElementById('frmRecuperacion').addEventListener('submit', function(e) {
      var input = document.querySelector('input[name="usuarioOCorreo"]');
      if (input.value.trim().length < 3) {
        e.preventDefault();
        alert('Por favor ingresa un usuario o correo válido');
        input.focus();
      }
    });
  </script>
</body>
</html>
