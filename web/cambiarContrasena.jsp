<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Verificar si existe un token
    String token = request.getParameter("token");
    if (token == null || token.trim().isEmpty()) {
        response.sendRedirect("recuperarContrasena.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Monster University | Cambiar Contraseña</title>
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
    
    .change-password-container {
      background: white;
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      overflow: hidden;
      max-width: 500px;
      width: 100%;
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
    
    .password-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      padding: 40px;
      color: white;
      text-align: center;
      position: relative;
    }
    
    .password-header::before {
      content: '🔑';
      display: block;
      font-size: 60px;
      margin-bottom: 15px;
    }
    
    .password-header h1 {
      font-size: 28px;
      font-weight: 700;
      margin-bottom: 8px;
    }
    
    .password-header p {
      font-size: 14px;
      opacity: 0.95;
      margin: 0;
    }
    
    .password-body {
      padding: 40px;
    }
    
    .form-group {
      margin-bottom: 25px;
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
      font-size: 16px;
      cursor: pointer;
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
    
    .password-strength {
      margin-top: 10px;
      font-size: 12px;
    }
    
    .strength-bar {
      height: 6px;
      background: #e0e0e0;
      border-radius: 3px;
      overflow: hidden;
      margin-top: 5px;
    }
    
    .strength-bar .strength {
      height: 100%;
      width: 0%;
      transition: width 0.3s ease, background 0.3s ease;
    }
    
    .strength.weak { background: #e63757; width: 33%; }
    .strength.medium { background: #f6c343; width: 66%; }
    .strength.strong { background: #00d97e; width: 100%; }
    
    .btn-change {
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
    }
    
    .btn-change:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
    }
    
    .btn-change:disabled {
      background: #ccc;
      cursor: not-allowed;
      transform: none;
    }
    
    .alert {
      border-radius: 10px;
      border: none;
      margin-bottom: 20px;
      font-size: 14px;
    }
    
    .alert-danger {
      background: #ffebee;
      color: #c62828;
    }
    
    .requirements {
      background: #f9f9f9;
      padding: 15px;
      border-radius: 10px;
      margin-top: 20px;
      font-size: 12px;
    }
    
    .requirements h4 {
      font-weight: 600;
      color: #333;
      margin-bottom: 10px;
      font-size: 13px;
    }
    
    .requirement {
      color: #999;
      margin-bottom: 6px;
      display: flex;
      align-items: center;
    }
    
    .requirement i {
      margin-right: 8px;
      width: 16px;
      text-align: center;
    }
    
    .requirement.valid { color: #00d97e; }
    .requirement.valid i::before { content: '✓'; color: #00d97e; }
  </style>
</head>
<body>
  <div class="change-password-container">
    <div class="password-header">
      <h1>Cambiar Contraseña</h1>
      <p>Crea una nueva contraseña segura</p>
    </div>
    
    <div class="password-body">
      <!-- Mensajes de error -->
      <c:if test="${not empty error}">
        <div class="alert alert-danger">
          <i class="fa fa-exclamation-circle"></i>
          ${error}
        </div>
      </c:if>
      
      <form method="POST" action="srvCambiarContrasena" id="frmCambiarPass">
        <!-- Token oculto -->
        <input type="hidden" name="token" value="<%= token %>">
        
        <div class="form-group">
          <label>Nueva Contraseña <span style="color: #e63757;">*</span></label>
          <div class="input-wrapper">
            <i class="fa fa-lock"></i>
            <input type="password" name="nuevaContrasena" id="nuevaContrasena" class="form-control" 
                   placeholder="Ingresa una contraseña fuerte" required>
          </div>
          <div class="password-strength">
            <small>Fortaleza:</small>
            <div class="strength-bar">
              <div class="strength" id="strengthBar"></div>
            </div>
          </div>
        </div>
        
        <div class="form-group">
          <label>Confirmar Contraseña <span style="color: #e63757;">*</span></label>
          <div class="input-wrapper">
            <i class="fa fa-lock" id="toggleConfirm" style="cursor: pointer;"></i>
            <input type="password" name="confirmarContrasena" id="confirmarContrasena" class="form-control" 
                   placeholder="Confirma tu nueva contraseña" required>
          </div>
        </div>
        
        <!-- Requisitos de contraseña -->
        <div class="requirements">
          <h4><i class="fa fa-shield"></i> Requisitos de Seguridad</h4>
          <div class="requirement" id="req-length">
            <i></i>
            <span>Mínimo 8 caracteres</span>
          </div>
          <div class="requirement" id="req-uppercase">
            <i></i>
            <span>Una letra mayúscula (A-Z)</span>
          </div>
          <div class="requirement" id="req-lowercase">
            <i></i>
            <span>Una letra minúscula (a-z)</span>
          </div>
          <div class="requirement" id="req-number">
            <i></i>
            <span>Un número (0-9)</span>
          </div>
          <div class="requirement" id="req-special">
            <i></i>
            <span>Un carácter especial (!@#$%)</span>
          </div>
        </div>
        
        <button type="submit" class="btn-change" id="btnSubmit">
          <i class="fa fa-check-circle"></i> Cambiar Contraseña
        </button>
      </form>
      
      <div style="text-align: center; margin-top: 20px;">
        <a href="identificar.jsp" style="color: #667eea; text-decoration: none; font-size: 14px;">
          <i class="fa fa-arrow-left"></i> Volver al Login
        </a>
      </div>
    </div>
  </div>

  <script src="${pageContext.request.contextPath}/bower_components/jquery/dist/jquery.min.js"></script>
  <script>
    const passInput = document.getElementById('nuevaContrasena');
    const confirmInput = document.getElementById('confirmarContrasena');
    const strengthBar = document.getElementById('strengthBar');
    const btnSubmit = document.getElementById('btnSubmit');
    
    // Validar contraseña en tiempo real
    passInput.addEventListener('input', function() {
      const pass = this.value;
      
      // Verificar requisitos
      const hasLength = pass.length >= 8;
      const hasUppercase = /[A-Z]/.test(pass);
      const hasLowercase = /[a-z]/.test(pass);
      const hasNumber = /\d/.test(pass);
      const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pass);
      
      // Actualizar requisitos
      updateRequirement('req-length', hasLength);
      updateRequirement('req-uppercase', hasUppercase);
      updateRequirement('req-lowercase', hasLowercase);
      updateRequirement('req-number', hasNumber);
      updateRequirement('req-special', hasSpecial);
      
      // Calcular fortaleza
      let strength = 0;
      if (hasLength) strength++;
      if (hasUppercase) strength++;
      if (hasLowercase) strength++;
      if (hasNumber) strength++;
      if (hasSpecial) strength++;
      
      // Mostrar fortaleza
      strengthBar.className = 'strength';
      if (strength <= 2) {
        strengthBar.classList.add('weak');
      } else if (strength <= 4) {
        strengthBar.classList.add('medium');
      } else {
        strengthBar.classList.add('strong');
      }
      
      validarFormulario();
    });
    
    confirmInput.addEventListener('input', validarFormulario);
    
    function updateRequirement(id, valid) {
      const elem = document.getElementById(id);
      if (valid) {
        elem.classList.add('valid');
      } else {
        elem.classList.remove('valid');
      }
    }
    
    function validarFormulario() {
      const pass = passInput.value;
      const confirm = confirmInput.value;
      
      const esValida = pass.length >= 8 && 
                       /[A-Z]/.test(pass) && 
                       /[a-z]/.test(pass) && 
                       /\d/.test(pass) && 
                       /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pass) &&
                       pass === confirm &&
                       confirm.length > 0;
      
      btnSubmit.disabled = !esValida;
    }
    
    // Validación al enviar
    document.getElementById('frmCambiarPass').addEventListener('submit', function(e) {
      const pass = passInput.value;
      const confirm = confirmInput.value;
      
      if (pass !== confirm) {
        e.preventDefault();
        alert('Las contraseñas no coinciden');
        return false;
      }
    });
  </script>
</body>
</html>
