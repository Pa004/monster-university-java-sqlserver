<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Verificar mensaje de éxito
    String mensaje = request.getParameter("mensaje");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Monster University | Dashboard</title>
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
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.78) 0%, rgba(118, 75, 162, 0.78) 100%),
                        url('${pageContext.request.contextPath}/images/Fondo03.jpg') center/cover no-repeat fixed;
            min-height: 100vh;
            padding: 40px 20px;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            margin-bottom: 40px;
        }
        .navbar .navbar-brand {
            font-size: 24px;
            font-weight: 700;
            color: white !important;
        }
        .nav-actions {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .navbar .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            transition: color 0.3s;
        }
        .navbar .nav-link:hover {
            color: white !important;
        }
        .container {
            max-width: 1100px;
            margin: 0 auto;
        }
        .dashboard-title {
            color: white;
            text-align: center;
            margin-bottom: 50px;
            font-size: 36px;
            font-weight: 700;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }
        .module-card {
            background: white;
            border-radius: 15px;
            padding: 40px 30px;
            text-align: center;
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 250px;
        }
        .module-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.3);
            text-decoration: none;
            color: inherit;
        }
        .module-icon {
            font-size: 48px;
            margin-bottom: 20px;
            color: #667eea;
        }
        .module-title {
            font-size: 22px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        .module-desc {
            font-size: 14px;
            color: #666;
        }
        .logout-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }
        .user-info {
            color: white;
            text-align: right;
            margin-bottom: 20px;
            font-size: 14px;
        }
        @media (max-width: 768px) {
            .dashboard-title {
                font-size: 28px;
            }
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container" style="display:flex; align-items:center;">
            <a class="navbar-brand" href="index.jsp">
                <i class="fa fa-graduation-cap"></i> Monster University
            </a>
            <div class="nav-actions">
                <form action="${pageContext.request.contextPath}/srvUsuario" method="POST" style="display:inline; margin:0;">
                    <input type="hidden" name="accion" value="logout">
                    <button type="submit" class="logout-btn"><i class="fa fa-sign-out"></i> Cerrar Sesión</button>
                </form>
            </div>
        </div>
    </nav>

    <!-- Mensaje de Éxito -->
    <% if ("contrasena_actualizada".equals(mensaje)) { %>
    <div class="container">
        <div class="alert alert-success alert-dismissible fade in" role="alert" style="animation: slideUp 0.6s ease-out; margin-bottom: 20px;">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            <strong><i class="fa fa-check-circle"></i> ¡Contraseña actualizada!</strong> Tu contraseña ha sido cambiada exitosamente.
        </div>
    </div>
    <% } %>

    <!-- User Info -->
    <div class="container">
        <div class="user-info">
            <strong>Bienvenido:</strong> ${nombreCompleto}<br>
            <small>${email}</small>
        </div>
    </div>

    <!-- Dashboard Title -->
    <div class="container">
        <h1 class="dashboard-title">
            <i class="fa fa-dashboard"></i> Panel de Administración
        </h1>
    </div>

    <!-- Dashboard Grid -->
    <div class="container">
        <div class="dashboard-grid">
            <!-- Gestión de Usuarios -->
            <a href="srvUsuario?accion=listar" class="module-card">
                <i class="fa fa-users module-icon"></i>
                <h3 class="module-title">Gestión de Usuarios</h3>
                <p class="module-desc">Crear, editar y eliminar usuarios del sistema</p>
            </a>

            <!-- Perfiles -->
            <a href="#" class="module-card">
                <i class="fa fa-shield module-icon"></i>
                <h3 class="module-title">Perfiles</h3>
                <p class="module-desc">Administrar perfiles y roles del sistema</p>
            </a>

            <!-- Permisos -->
            <a href="#" class="module-card">
                <i class="fa fa-key module-icon"></i>
                <h3 class="module-title">Permisos</h3>
                <p class="module-desc">Gestionar permisos y accesos</p>
            </a>

            <!-- Auditoría -->
            <a href="#" class="module-card">
                <i class="fa fa-history module-icon"></i>
                <h3 class="module-title">Auditoría</h3>
                <p class="module-desc">Ver registro de actividades</p>
            </a>

            <!-- Reportes -->
            <a href="srvUsuario?accion=listar" class="module-card">
                <i class="fa fa-bar-chart module-icon"></i>
                <h3 class="module-title">Reportes</h3>
                <p class="module-desc">Generar reportes de Usuarios y Estados</p>
            </a>

            <!-- Configuración -->
            <a href="#" class="module-card">
                <i class="fa fa-cog module-icon"></i>
                <h3 class="module-title">Configuración</h3>
                <p class="module-desc">Ajustes del sistema</p>
            </a>
        </div>
    </div>

    <!-- Footer -->
    <div class="container" style="text-align: center; color: white; margin-top: 50px;">
        <p>&copy; 2024 Monster University. Todos los derechos reservados.</p>
    </div>

    <script src="${pageContext.request.contextPath}/bower_components/jquery/dist/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
</body>
</html>
