<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("identificar.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Cambiar Contraseña | Monster U</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="bower_components/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="bower_components/Ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="dist/css/skins/_all-skins.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            font-family: Arial, sans-serif;
        }
        .container-cambio {
            max-width: 500px;
            width: 100%;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            padding: 40px;
            animation: slideIn 0.5s ease;
        }
        @keyframes slideIn {
            from {
                transform: translateY(-30px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        .logo-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .logo-header h1 {
            color: #667eea;
            font-size: 32px;
            margin: 0 0 10px 0;
            font-weight: 700;
        }
        .logo-header p {
            color: #999;
            font-size: 14px;
            margin: 0;
        }
        .alert-info-custom {
            background: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 25px;
            color: #0c5aa0;
            font-size: 14px;
        }
        .alert-info-custom strong {
            display: block;
            margin-bottom: 8px;
        }
        .form-group label {
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        .form-control {
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            padding: 12px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
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
        .strength-bar-fill {
            height: 100%;
            width: 0;
            border-radius: 3px;
            transition: all 0.3s ease;
        }
        .btn-cambiar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 6px;
            font-weight: 600;
            width: 100%;
            margin-top: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 16px;
        }
        .btn-cambiar:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            color: white;
        }
        .requirements {
            margin-top: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 6px;
            font-size: 12px;
        }
        .requirements h5 {
            color: #667eea;
            margin: 0 0 10px 0;
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
        }
        .req-item {
            color: #999;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
        }
        .req-item i {
            margin-right: 8px;
            color: #e0e0e0;
        }
        .req-item.ok i {
            color: #4caf50;
        }
        .req-item.ok {
            color: #4caf50;
        }
    </style>
</head>
<body>
<div class="container-cambio">
    <div class="logo-header">
        <h1>🎓 Monster University</h1>
        <p>Sistema de Gestión Académica</p>
    </div>
    
    <div class="alert-info-custom">
        <strong>🔒 Cambio de Contraseña Obligatorio</strong>
        Por razones de seguridad, debes cambiar tu contraseña antes de continuar. Esto es obligatorio en tu primer ingreso o si solicitaste recuperación.
    </div>
    
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade in" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
        <strong>Error:</strong> <%= request.getAttribute("error") %>
    </div>
    <% } %>
    
    <form action="srvCambiarContrasena?accion=cambiarContrasena" method="POST">
        <!-- Se elimina la solicitud de contraseña actual por requerimiento -->
        
        <div class="form-group" style="margin-top: 20px;">
            <label for="nuevaContrasena"><i class="fa fa-lock"></i> Nueva Contraseña</label>
            <input type="password" id="nuevaContrasena" name="nuevaContrasena" class="form-control" required onkeyup="verificarFortaleza()">
            <div class="password-strength">
                <div class="strength-bar">
                    <div id="strengthBar" class="strength-bar-fill"></div>
                </div>
                <span id="strengthText" style="color: #999;">Débil</span>
            </div>
        </div>
        
        <div class="form-group">
            <label for="confirmarContrasena"><i class="fa fa-lock"></i> Confirmar Contraseña</label>
            <input type="password" id="confirmarContrasena" name="confirmarContrasena" class="form-control" required>
        </div>
        
        <div class="requirements">
            <h5>Requisitos de Seguridad</h5>
            <div class="req-item" id="req-length">
                <i class="fa fa-circle-o"></i> Mínimo 8 caracteres
            </div>
            <div class="req-item" id="req-uppercase">
                <i class="fa fa-circle-o"></i> Al menos una mayúscula (A-Z)
            </div>
            <div class="req-item" id="req-lowercase">
                <i class="fa fa-circle-o"></i> Al menos una minúscula (a-z)
            </div>
            <div class="req-item" id="req-number">
                <i class="fa fa-circle-o"></i> Al menos un número (0-9)
            </div>
            <div class="req-item" id="req-special">
                <i class="fa fa-circle-o"></i> Al menos un carácter especial (!@#$%^&*)
            </div>
        </div>
        
        <button type="submit" class="btn-cambiar" id="btnCambiar" onclick="return validarFormulario()">
            <i class="fa fa-check"></i> Cambiar Contraseña
        </button>
    </form>
</div>

<script src="bower_components/jquery/dist/jquery.min.js"></script>
<script src="bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<script>
    function verificarFortaleza() {
        const password = document.getElementById('nuevaContrasena').value;
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        
        let fuerza = 0;
        const requisitos = {
            length: password.length >= 8,
            uppercase: /[A-Z]/.test(password),
            lowercase: /[a-z]/.test(password),
            number: /[0-9]/.test(password),
            special: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)
        };
        
        // Actualizar UI de requisitos
        document.getElementById('req-length').className = 'req-item' + (requisitos.length ? ' ok' : '');
        document.getElementById('req-uppercase').className = 'req-item' + (requisitos.uppercase ? ' ok' : '');
        document.getElementById('req-lowercase').className = 'req-item' + (requisitos.lowercase ? ' ok' : '');
        document.getElementById('req-number').className = 'req-item' + (requisitos.number ? ' ok' : '');
        document.getElementById('req-special').className = 'req-item' + (requisitos.special ? ' ok' : '');
        
        // Calcular fuerza
        fuerza = Object.values(requisitos).filter(Boolean).length;
        
        // Actualizar barra
        const porcentaje = (fuerza / 5) * 100;
        strengthBar.style.width = porcentaje + '%';
        
        if (fuerza <= 2) {
            strengthBar.style.backgroundColor = '#f44336';
            strengthText.textContent = 'Débil';
            strengthText.style.color = '#f44336';
        } else if (fuerza <= 3) {
            strengthBar.style.backgroundColor = '#ff9800';
            strengthText.textContent = 'Moderada';
            strengthText.style.color = '#ff9800';
        } else if (fuerza <= 4) {
            strengthBar.style.backgroundColor = '#2196f3';
            strengthText.textContent = 'Fuerte';
            strengthText.style.color = '#2196f3';
        } else {
            strengthBar.style.backgroundColor = '#4caf50';
            strengthText.textContent = 'Muy fuerte';
            strengthText.style.color = '#4caf50';
        }
    }
    
    function validarFormulario() {
        const contrasena = document.getElementById('nuevaContrasena').value;
        const confirmar = document.getElementById('confirmarContrasena').value;
        
        // Validar requisitos mínimos
        if (contrasena.length < 8) {
            alert('La contraseña debe tener al menos 8 caracteres');
            return false;
        }
        if (!/[A-Z]/.test(contrasena)) {
            alert('La contraseña debe contener al menos una mayúscula');
            return false;
        }
        if (!/[a-z]/.test(contrasena)) {
            alert('La contraseña debe contener al menos una minúscula');
            return false;
        }
        if (!/[0-9]/.test(contrasena)) {
            alert('La contraseña debe contener al menos un número');
            return false;
        }
        if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(contrasena)) {
            alert('La contraseña debe contener al menos un carácter especial (!@#$%^&*()_+-=[]{};\':"|,.<>/?)');
            return false;
        }
        
        // No se requiere validar contra contraseña actual
        
        // Validar coincidencia
        if (contrasena !== confirmar) {
            alert('Las contraseñas no coinciden');
            return false;
        }
        
        return true;
    }
    
    // Verificar fortaleza al cargar
    document.addEventListener('DOMContentLoaded', function() {
        verificarFortaleza();
    });
</script>
</body>
</html>
