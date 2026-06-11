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
  <title>Gestión de Usuarios | Monster U</title>
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="bower_components/font-awesome/css/font-awesome.min.css">
  <link rel="stylesheet" href="bower_components/Ionicons/css/ionicons.min.css">
  <link rel="stylesheet" href="dist/css/AdminLTE.min.css">
  <link rel="stylesheet" href="dist/css/skins/_all-skins.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
  <style>
    /* Badges mejorados */
    .badge-activo { 
      background: linear-gradient(135deg, #00a65a 0%, #00c073 100%);
      padding: 6px 12px;
      font-size: 12px;
      font-weight: 600;
      border-radius: 20px;
      box-shadow: 0 2px 4px rgba(0, 166, 90, 0.3);
    }
    .badge-inactivo { 
      background: linear-gradient(135deg, #dd4b39 0%, #e74c3c 100%);
      padding: 6px 12px;
      font-size: 12px;
      font-weight: 600;
      border-radius: 20px;
      box-shadow: 0 2px 4px rgba(221, 75, 57, 0.3);
    }
    
    /* Tabla mejorada */
    .table-hover tbody tr {
      transition: all 0.3s ease;
    }
    .table-hover tbody tr:hover { 
      background-color: #f8f9fa;
      transform: scale(1.01);
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    
    .table thead th {
      background: linear-gradient(135deg, #3c8dbc 0%, #5ba3d0 100%);
      color: white;
      border: none;
      font-weight: 600;
      text-transform: uppercase;
      font-size: 12px;
      letter-spacing: 0.5px;
      padding: 15px 10px;
    }
    
    .table tbody td {
      vertical-align: middle;
      padding: 12px 10px;
    }
    
    /* Botones de acción mejorados */
    .btn-group .btn {
      transition: all 0.3s ease;
      margin: 0 2px;
    }
    
    .btn-group .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }
    
    .btn-info {
      background: linear-gradient(135deg, #17a2b8 0%, #1fc8e3 100%);
      border: none;
    }
    
    .btn-warning {
      background: linear-gradient(135deg, #f39c12 0%, #f5b041 100%);
      border: none;
    }
    
    .btn-danger {
      background: linear-gradient(135deg, #dd4b39 0%, #e74c3c 100%);
      border: none;
    }
    
    .btn-success {
      background: linear-gradient(135deg, #00a65a 0%, #00c073 100%);
      border: none;
    }
    
    /* Box mejorado */
    .box {
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      transition: all 0.3s ease;
      margin-bottom: 25px;
    }
    
    .box:hover {
      box-shadow: 0 6px 20px rgba(0,0,0,0.12);
    }
    
    .box-header {
      border-radius: 8px 8px 0 0;
      background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
      border-bottom: 3px solid #3c8dbc;
    }
    
    .box-title {
      font-weight: 700;
      font-size: 18px;
      color: #3c8dbc;
    }
    
    /* Modal mejorado */
    .modal-content {
      border-radius: 12px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.2);
      border: none;
    }
    
    .modal-header {
      background: linear-gradient(135deg, #3c8dbc 0%, #5ba3d0 100%);
      color: white;
      border-radius: 12px 12px 0 0;
      padding: 20px;
    }
    
    .modal-header .modal-title {
      font-weight: 700;
      font-size: 20px;
    }
    
    .modal-header .close {
      color: white;
      opacity: 0.9;
      text-shadow: none;
    }
    
    .modal-body {
      padding: 25px;
    }
    
    .modal-body .form-group {
      margin-bottom: 20px;
      padding: 15px;
      background: #f8f9fa;
      border-radius: 8px;
      border-left: 4px solid #3c8dbc;
    }
    
    .modal-body .form-group label {
      color: #3c8dbc;
      font-weight: 600;
      font-size: 13px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 8px;
    }
    
    .modal-body .form-control-static {
      font-size: 15px;
      color: #333;
      padding: 5px 0;
    }
    
    /* Formulario de búsqueda mejorado */
    .form-control {
      border-radius: 6px;
      border: 2px solid #e0e0e0;
      transition: all 0.3s ease;
    }
    
    .form-control:focus {
      border-color: #3c8dbc;
      box-shadow: 0 0 0 0.2rem rgba(60, 141, 188, 0.25);
    }
    
    /* Alertas mejoradas */
    .alert {
      border-radius: 8px;
      border: none;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      animation: slideInDown 0.5s ease;
    }
    
    @keyframes slideInDown {
      from {
        transform: translateY(-20px);
        opacity: 0;
      }
      to {
        transform: translateY(0);
        opacity: 1;
      }
    }
    
    /* Badge de contador */
    .badge-counter {
      background: linear-gradient(135deg, #3c8dbc 0%, #5ba3d0 100%);
      color: white;
      padding: 8px 15px;
      border-radius: 20px;
      font-weight: 600;
      font-size: 14px;
      box-shadow: 0 2px 6px rgba(60, 141, 188, 0.3);
    }
    
    /* Iconos con animación */
    .fa {
      transition: all 0.3s ease;
    }
    
    .btn:hover .fa {
      transform: scale(1.2);
    }
    
    /* Mejora del contenido */
    .content-header h1 {
      font-weight: 700;
      color: #2c3e50;
    }
    
    .content-header h1 small {
      font-weight: 400;
      color: #7f8c8d;
    }
    
    /* ========== MEJORAS DEL SIDEBAR ========== */
    
    /* Sidebar principal */
    .main-sidebar {
      background: #222d32;
      box-shadow: 2px 0 6px rgba(0,0,0,0.1);
    }
    
    /* Panel de usuario mejorado */
    .user-panel {
      padding: 15px;
      border-bottom: 1px solid rgba(255,255,255,0.1);
    }
    
    .user-panel .image img {
      border: 2px solid #3c8dbc;
      transition: all 0.3s ease;
    }
    
    .user-panel:hover .image img {
      border-color: #5ba3d0;
    }
    
    .user-panel .info p {
      color: #fff;
      font-weight: 600;
      font-size: 14px;
    }
    
    .user-panel .info a {
      color: #b8c7ce;
      font-size: 12px;
    }
    
    /* Header del menú */
    .sidebar-menu .header {
      color: #4b646f;
      padding: 10px 15px;
      font-weight: 700;
      font-size: 11px;
      letter-spacing: 0.5px;
      text-transform: uppercase;
    }
    
    /* Items del menú */
    .sidebar-menu > li > a {
      padding: 12px 15px;
      transition: all 0.3s ease;
      border-left: 3px solid transparent;
    }
    
    .sidebar-menu > li > a:hover {
      background: rgba(60,141,188,0.1);
      border-left: 3px solid #3c8dbc;
      color: #fff;
    }
    
    .sidebar-menu > li.active > a {
      background: #1e282c;
      border-left: 3px solid #3c8dbc;
      color: #fff;
      font-weight: 600;
    }
    
    .sidebar-menu > li > a > .fa {
      font-size: 16px;
      margin-right: 10px;
      width: 20px;
      text-align: center;
    }
  </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  <!-- Header -->
  <header class="main-header">
    <a href="index.jsp" class="logo">
      <span class="logo-mini"><b>M</b>U</span>
      <span class="logo-lg"><b>Monster</b>University</span>
    </a>
    
    <nav class="navbar navbar-static-top">
      <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <c:choose>
                <c:when test="${not empty sessionScope.fotoPath}">
                  <img src="media?p=${sessionScope.fotoPath}" class="user-image" alt="User Image">
                </c:when>
                <c:otherwise>
                  <img src="dist/img/user2-160x160.jpg" class="user-image" alt="User Image">
                </c:otherwise>
              </c:choose>
              <span class="hidden-xs">${sessionScope.nombreCompleto}</span>
            </a>
            <ul class="dropdown-menu">
              <li class="user-header">
                <c:choose>
                  <c:when test="${not empty sessionScope.fotoPath}">
                    <img src="media?p=${sessionScope.fotoPath}" class="img-circle" alt="User Image">
                  </c:when>
                  <c:otherwise>
                    <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                  </c:otherwise>
                </c:choose>
                <p>${sessionScope.nombreCompleto}<small>${sessionScope.email}</small></p>
              </li>
              <li class="user-footer">
                <div class="pull-right">
                  <a href="srvUsuario?accion=logout" class="btn btn-default btn-flat">Cerrar Sesión</a>
                </div>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>
  </header>

  <!-- Sidebar -->
  <aside class="main-sidebar">
    <section class="sidebar">
      <!-- Panel de usuario mejorado -->
      <div class="user-panel">
        <div class="pull-left image">
          <c:choose>
            <c:when test="${not empty sessionScope.fotoPath}">
              <img src="media?p=${sessionScope.fotoPath}" class="img-circle" alt="User Image">
            </c:when>
            <c:otherwise>
              <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
            </c:otherwise>
          </c:choose>
        </div>
        <div class="pull-left info">
          <p>${sessionScope.nombreCompleto}</p>
          <a href="#"><i class="fa fa-circle text-success"></i> En línea</a>
        </div>
      </div>
      
      <!-- Menú lateral simplificado -->
      <ul class="sidebar-menu" data-widget="tree">
        <li class="header">MENÚ PRINCIPAL</li>
        
        <li>
          <a href="index.jsp">
            <i class="fa fa-home"></i>
            <span>Inicio</span>
          </a>
        </li>
        
        <li class="active">
          <a href="srvUsuario?accion=listar">
            <i class="fa fa-users"></i>
            <span>Gestión de Usuarios</span>
          </a>
        </li>
        
        <li>
          <a href="srvUsuario?accion=logout">
            <i class="fa fa-sign-out"></i>
            <span>Cerrar Sesión</span>
          </a>
        </li>
      </ul>
    </section>
  </aside>

  <!-- Content -->
  <div class="content-wrapper">
    <section class="content-header">
      <h1>Gestión de Usuarios<small>Administración del sistema</small></h1>
      <ol class="breadcrumb">
        <li><a href="index.jsp"><i class="fa fa-dashboard"></i> Inicio</a></li>
        <li class="active">Usuarios</li>
      </ol>
    </section>

    <section class="content">
      
      <!-- Mensajes -->
      <c:if test="${not empty param.mensaje}">
        <div class="alert alert-${param.tipo == 'success' ? 'success' : 'danger'} alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-${param.tipo == 'success' ? 'check' : 'ban'}"></i> ${param.tipo == 'success' ? '¡Éxito!' : '¡Error!'}</h4>
          ${param.mensaje}
        </div>
      </c:if>
      
      <!-- Tarjetas de estadísticas rápidas -->
      <div class="row" style="margin-bottom: 20px;">
        <div class="col-lg-3 col-xs-6">
          <div class="small-box" style="background: linear-gradient(135deg, #3c8dbc 0%, #5ba3d0 100%); border-radius: 8px; box-shadow: 0 4px 12px rgba(60,141,188,0.3);">
            <div class="inner" style="padding: 15px;">
              <h3 style="color: white; font-weight: 700;">${not empty usuarios ? usuarios.size() : 0}</h3>
              <p style="color: rgba(255,255,255,0.9); font-weight: 600;">Total Usuarios</p>
            </div>
            <div class="icon" style="color: rgba(255,255,255,0.3); font-size: 70px; position: absolute; top: 10px; right: 15px;">
              <i class="fa fa-users"></i>
            </div>
          </div>
        </div>
        
        <div class="col-lg-3 col-xs-6">
          <div class="small-box" style="background: linear-gradient(135deg, #00a65a 0%, #00c073 100%); border-radius: 8px; box-shadow: 0 4px 12px rgba(0,166,90,0.3);">
            <div class="inner" style="padding: 15px;">
              <h3 style="color: white; font-weight: 700;"><span id="statsActiveCount">0</span></h3>
              <p style="color: rgba(255,255,255,0.9); font-weight: 600;">Usuarios Activos</p>
            </div>
            <div class="icon" style="color: rgba(255,255,255,0.3); font-size: 70px; position: absolute; top: 10px; right: 15px;">
              <i class="fa fa-check-circle"></i>
            </div>
          </div>
        </div>
        
        <div class="col-lg-3 col-xs-6">
          <div class="small-box" style="background: linear-gradient(135deg, #dd4b39 0%, #e74c3c 100%); border-radius: 8px; box-shadow: 0 4px 12px rgba(221,75,57,0.3);">
            <div class="inner" style="padding: 15px;">
              <h3 style="color: white; font-weight: 700;"><span id="statsInactiveCount">0</span></h3>
              <p style="color: rgba(255,255,255,0.9); font-weight: 600;">Usuarios Inactivos</p>
            </div>
            <div class="icon" style="color: rgba(255,255,255,0.3); font-size: 70px; position: absolute; top: 10px; right: 15px;">
              <i class="fa fa-times-circle"></i>
            </div>
          </div>
        </div>
        
        <div class="col-lg-3 col-xs-6">
          <div class="small-box" style="background: linear-gradient(135deg, #f39c12 0%, #f5b041 100%); border-radius: 8px; box-shadow: 0 4px 12px rgba(243,156,18,0.3);">
            <div class="inner" style="padding: 15px;">
              <h3 style="color: white; font-weight: 700;"><i class="fa fa-shield"></i></h3>
              <p style="color: rgba(255,255,255,0.9); font-weight: 600;">Administración</p>
            </div>
            <div class="icon" style="color: rgba(255,255,255,0.3); font-size: 70px; position: absolute; top: 10px; right: 15px;">
              <i class="fa fa-cog"></i>
            </div>
          </div>
        </div>
      </div>

      <!-- Filtros de búsqueda -->
      <div class="box box-primary">
        <div class="box-header with-border">
          <h3 class="box-title"><i class="fa fa-search"></i> Buscar Usuarios</h3>
        </div>
        <form action="srvUsuario" method="GET">
          <input type="hidden" name="accion" value="buscar">
          <div class="box-body">
            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label>Nombre / Username:</label>
                  <input type="text" name="nombre" class="form-control" placeholder="Buscar por nombre o usuario" value="${nombreBusqueda}">
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>Rol:</label>
                  <select name="rol" class="form-control">
                    <option value="">Todos los roles</option>
                    <c:forEach items="${perfiles}" var="perfil">
                      <option value="${perfil.codigo}" ${rolBusqueda == perfil.codigo ? 'selected' : ''}>${perfil.descripcion}</option>
                    </c:forEach>
                  </select>
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>Estado:</label>
                  <select name="estado" class="form-control">
                    <option value="">Todos</option>
                    <option value="A" ${estadoBusqueda == 'A' ? 'selected' : ''}>Activos</option>
                    <option value="I" ${estadoBusqueda == 'I' ? 'selected' : ''}>Inactivos</option>
                  </select>
                </div>
              </div>
              <div class="col-md-2">
                <div class="form-group">
                  <label>&nbsp;</label>
                  <button type="submit" class="btn btn-primary btn-block"><i class="fa fa-search"></i> Buscar</button>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>

      <!-- Tabla de usuarios -->
      <div class="box box-primary">
        <div class="box-header with-border">
          <h3 class="box-title"><i class="fa fa-users"></i> Lista de Usuarios</h3>
          <div class="box-tools" style="display:flex; gap:8px;">
            <a href="srvUsuario?accion=exportarCsv" class="btn btn-default btn-sm" title="Exportar CSV">
              <i class="fa fa-file-excel-o"></i> CSV
            </a>
            <a href="srvUsuario?accion=exportarPdf" class="btn btn-default btn-sm" title="Exportar PDF">
              <i class="fa fa-file-pdf-o"></i> PDF
            </a>
            <a href="srvUsuario?accion=nuevo" class="btn btn-success">
              <i class="fa fa-plus"></i> Nuevo Usuario
            </a>
          </div>
        </div>
        <div class="box-body">
          <c:choose>
            <c:when test="${not empty usuarios}">
              <div class="table-responsive">
                <table class="table table-bordered table-striped table-hover">
                  <thead>
                    <tr>
                      <th>Foto</th>
                      <th>ID</th>
                      <th>Usuario</th>
                      <th>Nombre Completo</th>
                      <th>Tipo</th>
                      <th>ID Académico</th>
                      <th>Email</th>
                      <th>Estado</th>
                      <th>Acciones</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${usuarios}" var="usuario">
                      <tr>
                        <td>
                           <img src="${empty usuario.fotoPath ? 'dist/img/user2-160x160.jpg' : 'media?p='}${empty usuario.fotoPath ? '' : usuario.fotoPath}"
                               alt="Foto"
                               style="width:40px; height:40px; object-fit:cover; border-radius:50%; border:2px solid #3c8dbc;">
                        </td>
                        <td>${usuario.usuIdUsuario}</td>
                        <td><strong>${usuario.username}</strong></td>
                        <td>${usuario.nombreCompleto}</td>
                        <td>
                          <c:choose>
                            <c:when test="${usuario.tipoUsuario == 'ESTUDIANTE' || not empty usuario.idEstudiante}">
                              <span class="badge" style="background: linear-gradient(135deg, #f39c12 0%, #f5b041 100%); padding: 6px 12px; font-size: 11px; border-radius: 15px; box-shadow: 0 2px 4px rgba(243,156,18,0.3);">
                                <i class="fa fa-graduation-cap"></i> Estudiante
                              </span>
                            </c:when>
                            <c:when test="${usuario.tipoUsuario == 'DOCENTE' || not empty usuario.idDocente}">
                              <span class="badge" style="background: linear-gradient(135deg, #605ca8 0%, #7c78b8 100%); padding: 6px 12px; font-size: 11px; border-radius: 15px; box-shadow: 0 2px 4px rgba(96,92,168,0.3);">
                                <i class="fa fa-chalkboard-teacher"></i> Docente
                              </span>
                            </c:when>
                            <c:when test="${usuario.tipoUsuario == 'SECRETARIO_ACADEMICO' || usuario.tipoUsuario == 'SECRETARIO'}">
                              <span class="badge" style="background: linear-gradient(135deg, #00c0ef 0%, #5bc0de 100%); padding: 6px 12px; font-size: 11px; border-radius: 15px; box-shadow: 0 2px 4px rgba(0,192,239,0.25);">
                                <i class="fa fa-university"></i> Secretario Académico
                              </span>
                            </c:when>
                            <c:when test="${usuario.tipoUsuario == 'ADMINISTRADOR' || usuario.tipoUsuario == 'ADMIN'}">
                              <span class="badge" style="background: linear-gradient(135deg, #34495e 0%, #5d6d7e 100%); padding: 6px 12px; font-size: 11px; border-radius: 15px; box-shadow: 0 2px 4px rgba(52,73,94,0.25);">
                                <i class="fa fa-shield"></i> Administrador
                              </span>
                            </c:when>
                            <c:otherwise>
                              <span class="badge" style="background: #95a5a6; padding: 6px 12px; font-size: 11px; border-radius: 15px;">
                                <i class="fa fa-user"></i> Usuario
                              </span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${not empty usuario.idAcademico}">
                              <strong style="color: #f39c12; font-family: monospace;">${usuario.idAcademico}</strong>
                            </c:when>
                            <c:when test="${not empty usuario.idEstudiante}">
                              <strong style="color: #f39c12; font-family: monospace;">${usuario.idEstudiante}</strong>
                            </c:when>
                            <c:when test="${not empty usuario.idDocente}">
                              <strong style="color: #605ca8; font-family: monospace;">${usuario.idDocente}</strong>
                            </c:when>
                            <c:otherwise>
                              <span style="color: #95a5a6;">-</span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>${usuario.emailUsuario}</td>
                        <td>
                          <c:choose>
                            <c:when test="${usuario.estadoCodigo == 'A'}">
                              <span class="badge badge-activo">Activo</span>
                            </c:when>
                            <c:otherwise>
                              <span class="badge badge-inactivo">Inactivo</span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <div class="btn-group">
                            <button class="btn btn-sm btn-info" title="Ver Datos" data-toggle="modal" data-target="#modalVerUsuario" onclick="cargarDatosUsuario(${usuario.usuIdUsuario}, '${usuario.username}', '${usuario.nombreCompleto}', '${usuario.emailUsuario}', '${usuario.cedula}', '${usuario.estadoCodigo}', '${usuario.idEstudiante}', '${usuario.idDocente}', '${usuario.tipoUsuario}', '${usuario.idAcademico}', '${empty usuario.fotoPath ? 'dist/img/user2-160x160.jpg' : 'media?p='}${empty usuario.fotoPath ? '' : usuario.fotoPath}')">
                              <i class="fa fa-eye"></i>
                            </button>
                            <a href="srvUsuario?accion=editar&id=${usuario.usuIdUsuario}" class="btn btn-sm btn-warning" title="Editar">
                              <i class="fa fa-edit"></i>
                            </a>
                            <c:choose>
                              <c:when test="${usuario.estadoCodigo == 'A'}">
                                <a href="srvUsuario?accion=cambiarEstado&id=${usuario.usuIdUsuario}&estado=I" 
                                   class="btn btn-sm btn-danger" 
                                   title="Desactivar"
                                   onclick="return confirm('¿Desea desactivar este usuario?')">
                                  <i class="fa fa-ban"></i>
                                </a>
                              </c:when>
                              <c:otherwise>
                                <a href="srvUsuario?accion=cambiarEstado&id=${usuario.usuIdUsuario}&estado=A" 
                                   class="btn btn-sm btn-success" 
                                   title="Activar"
                                   onclick="return confirm('¿Desea activar este usuario?')">
                                  <i class="fa fa-check"></i>
                                </a>
                              </c:otherwise>
                            </c:choose>
                            <a href="srvUsuario?accion=eliminar&id=${usuario.usuIdUsuario}" 
                               class="btn btn-sm btn-danger" 
                               title="Eliminar"
                               onclick="return confirm('¿Está seguro de eliminar este usuario?')">
                              <i class="fa fa-trash"></i>
                            </a>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
              <div class="box-footer clearfix" style="background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%); padding: 20px; border-radius: 0 0 8px 8px;">
                <div class="row text-center">
                  <div class="col-md-4">
                    <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08);">
                      <h4 style="margin: 0; color: #3c8dbc; font-weight: 700;">
                        <i class="fa fa-users"></i> ${usuarios.size()}
                      </h4>
                      <small style="color: #7f8c8d; font-weight: 600;">Total Usuarios</small>
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08);">
                      <h4 style="margin: 0; color: #00a65a; font-weight: 700;">
                        <i class="fa fa-check-circle"></i> <span id="activeCount">-</span>
                      </h4>
                      <small style="color: #7f8c8d; font-weight: 600;">Activos</small>
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08);">
                      <h4 style="margin: 0; color: #dd4b39; font-weight: 700;">
                        <i class="fa fa-times-circle"></i> <span id="inactiveCount">-</span>
                      </h4>
                      <small style="color: #7f8c8d; font-weight: 600;">Inactivos</small>
                    </div>
                  </div>
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <div class="alert alert-info" style="text-align: center; padding: 30px;">
                <i class="icon fa fa-info-circle" style="font-size: 48px; margin-bottom: 15px;"></i>
                <h4>No hay usuarios registrados</h4>
                <p>Comienza agregando el primer usuario al sistema</p>
                <a href="srvUsuario?accion=nuevo" class="btn btn-primary" style="margin-top: 10px;">
                  <i class="fa fa-plus"></i> Crear Primer Usuario
                </a>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      
      <!-- Modal Ver Datos Personales del Usuario -->
      <div class="modal fade" id="modalVerUsuario" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h4 class="modal-title"><i class="fa fa-user-circle"></i> Información del Usuario</h4>
            </div>
            <div class="modal-body">
              <!-- Avatar y nombre -->
              <div class="text-center" style="margin-bottom: 30px; padding: 20px; background: linear-gradient(135deg, #3c8dbc 0%, #5ba3d0 100%); border-radius: 8px;">
                <div style="display: inline-block; width: 90px; height: 90px; background: white; border-radius: 50%; padding: 5px; box-shadow: 0 4px 12px rgba(0,0,0,0.2);">
                  <img id="modalFoto"
                       src="dist/img/user2-160x160.jpg"
                       alt="Foto"
                       style="width:80px; height:80px; object-fit:cover; border-radius:50%; border:2px solid #3c8dbc;">
                </div>
                <h3 style="color: white; margin: 15px 0 5px 0; font-weight: 700;" id="modalNombreCompletoHeader"></h3>
                <p style="color: rgba(255,255,255,0.9); margin: 0;" id="modalUsernameHeader"></p>
              </div>
              
              <!-- Tipo de Usuario -->
              <div class="text-center" style="margin-bottom: 20px;">
                <div id="modalTipoUsuario" style="display: inline-block;"></div>
              </div>
              
              <!-- Información en dos columnas -->
              <div class="row">
                <div class="col-md-6">
                  <div class="form-group">
                    <label><i class="fa fa-id-card"></i> ID Usuario</label>
                    <p id="modalId" class="form-control-static"></p>
                  </div>
                  <div class="form-group">
                    <label><i class="fa fa-user"></i> Username</label>
                    <p id="modalUsername" class="form-control-static"></p>
                  </div>
                  <div class="form-group" id="modalIdAcademicoGroup" style="display: none;">
                    <label><i class="fa fa-graduation-cap"></i> ID Académico</label>
                    <p id="modalIdAcademico" class="form-control-static" style="font-family: monospace; font-size: 16px; font-weight: 700;"></p>
                  </div>
                  <div class="form-group">
                    <label><i class="fa fa-envelope"></i> Email</label>
                    <p id="modalEmail" class="form-control-static"></p>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="form-group">
                    <label><i class="fa fa-id-badge"></i> Cédula</label>
                    <p id="modalCedula" class="form-control-static"></p>
                  </div>
                  <div class="form-group">
                    <label><i class="fa fa-address-card"></i> Nombre Completo</label>
                    <p id="modalNombreCompleto" class="form-control-static"></p>
                  </div>
                  <div class="form-group">
                    <label><i class="fa fa-toggle-on"></i> Estado</label>
                    <p id="modalEstado"></p>
                  </div>
                </div>
              </div>
            </div>
            <div class="modal-footer" style="background: #f8f9fa; border-radius: 0 0 12px 12px;">
              <button type="button" class="btn btn-default" data-dismiss="modal" style="padding: 8px 20px;">
                <i class="fa fa-times"></i> Cerrar
              </button>
            </div>
          </div>
        </div>
      </div>
      
    </section>
  </div>

  <!-- Footer -->
  <footer class="main-footer">
    <div class="pull-right hidden-xs"><b>Version</b> 1.0.0</div>
    <strong>Copyright &copy; 2024 Monster University.</strong> Todos los derechos reservados.
  </footer>
</div>

<script src="bower_components/jquery/dist/jquery.min.js"></script>
<script src="bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<script src="dist/js/adminlte.min.js"></script>

<script>
  // Función para cargar datos del usuario en el modal
  function cargarDatosUsuario(id, username, nombre, email, cedula, estado, idEstudiante, idDocente, tipoUsuario, idAcademico, fotoPath) {
    // Llenar los campos del modal con los datos
    document.getElementById('modalId').textContent = id;
    document.getElementById('modalUsername').textContent = username;
    document.getElementById('modalNombreCompleto').textContent = nombre;
    document.getElementById('modalEmail').textContent = email;
    document.getElementById('modalCedula').textContent = cedula;
    
    // Header del modal
    document.getElementById('modalNombreCompletoHeader').textContent = nombre;
    document.getElementById('modalUsernameHeader').textContent = '@' + username;
    // Foto de perfil
    var foto = (fotoPath && fotoPath !== '' && fotoPath !== 'null') ? fotoPath : 'dist/img/user2-160x160.jpg';
    var imgEl = document.getElementById('modalFoto');
    if (imgEl) { imgEl.src = foto; }
    
    // Mostrar tipo de usuario y ID académico
    let tipoBadge = '';
    let idAcademicoVal = '';
    let mostrarIdAcademico = false;
    
    if (idAcademico && idAcademico !== '' && idAcademico !== 'null') {
      idAcademicoVal = idAcademico;
      mostrarIdAcademico = true;
    }
    if (idEstudiante && idEstudiante !== '' && idEstudiante !== 'null') {
      tipoBadge = '<span class="badge" style="background: linear-gradient(135deg, #f39c12 0%, #f5b041 100%); padding: 10px 20px; font-size: 14px; border-radius: 20px; box-shadow: 0 3px 8px rgba(243,156,18,0.4);"><i class="fa fa-graduation-cap"></i> ESTUDIANTE</span>';
      if (!idAcademicoVal) { idAcademicoVal = idEstudiante; mostrarIdAcademico = true; }
    } else if (idDocente && idDocente !== '' && idDocente !== 'null') {
      tipoBadge = '<span class="badge" style="background: linear-gradient(135deg, #605ca8 0%, #7c78b8 100%); padding: 10px 20px; font-size: 14px; border-radius: 20px; box-shadow: 0 3px 8px rgba(96,92,168,0.4);"><i class="fa fa-chalkboard-teacher"></i> DOCENTE</span>';
      if (!idAcademicoVal) { idAcademicoVal = idDocente; mostrarIdAcademico = true; }
    } else if (tipoUsuario && tipoUsuario !== 'null' && tipoUsuario !== '') {
      var t = tipoUsuario.toUpperCase();
      if (t === 'ADMINISTRADOR' || t === 'ADMIN') {
        tipoBadge = '<span class="badge" style="background: linear-gradient(135deg, #34495e 0%, #5d6d7e 100%); padding: 10px 20px; font-size: 14px; border-radius: 20px; box-shadow: 0 3px 8px rgba(52,73,94,0.25);"><i class="fa fa-shield"></i> ADMINISTRADOR</span>';
      } else if (t.indexOf('SECRETARIO') >= 0 || t.indexOf('ACADEM') >= 0) {
        tipoBadge = '<span class="badge" style="background: linear-gradient(135deg, #00c0ef 0%, #5bc0de 100%); padding: 10px 20px; font-size: 14px; border-radius: 20px; box-shadow: 0 3px 8px rgba(0,192,239,0.25);"><i class="fa fa-university"></i> SECRETARIO ACADÉMICO</span>';
      } else {
        tipoBadge = '<span class="badge" style="background: #95a5a6; padding: 10px 20px; font-size: 14px; border-radius: 20px;"><i class="fa fa-user"></i> ' + t + '</span>';
      }
    } else {
      tipoBadge = '<span class="badge" style="background: #95a5a6; padding: 10px 20px; font-size: 14px; border-radius: 20px;"><i class="fa fa-user"></i> USUARIO GENERAL</span>';
    }
    
    document.getElementById('modalTipoUsuario').innerHTML = tipoBadge;
    
    // Mostrar u ocultar ID académico
    if (mostrarIdAcademico) {
      document.getElementById('modalIdAcademicoGroup').style.display = 'block';
      document.getElementById('modalIdAcademico').textContent = idAcademicoVal;
      if (idDocente && idDocente !== '' && idDocente !== 'null') {
        document.getElementById('modalIdAcademico').style.color = '#605ca8';
      } else {
        document.getElementById('modalIdAcademico').style.color = '#f39c12';
      }
    } else {
      document.getElementById('modalIdAcademicoGroup').style.display = 'none';
    }
    
    // Mostrar estado con badge mejorado
    let estadoBadge = '';
    if (estado === 'A') {
      estadoBadge = '<span class="badge badge-activo"><i class="fa fa-check-circle"></i> Activo</span>';
    } else {
      estadoBadge = '<span class="badge badge-inactivo"><i class="fa fa-times-circle"></i> Inactivo</span>';
    }
    document.getElementById('modalEstado').innerHTML = estadoBadge;
  }
  
  // Función para contar usuarios activos e inactivos
  function contarUsuarios() {
    let activos = 0;
    let inactivos = 0;
    
    // Contar badges en la tabla
    document.querySelectorAll('.badge-activo').forEach(function() {
      activos++;
    });
    
    document.querySelectorAll('.badge-inactivo').forEach(function() {
      inactivos++;
    });
    
    // Actualizar contadores del footer de la tabla
    const activeCountEl = document.getElementById('activeCount');
    const inactiveCountEl = document.getElementById('inactiveCount');
    
    if (activeCountEl) activeCountEl.textContent = activos;
    if (inactiveCountEl) inactiveCountEl.textContent = inactivos;
    
    // Actualizar contadores de las tarjetas superiores
    const statsActiveEl = document.getElementById('statsActiveCount');
    const statsInactiveEl = document.getElementById('statsInactiveCount');
    
    if (statsActiveEl) statsActiveEl.textContent = activos;
    if (statsInactiveEl) statsInactiveEl.textContent = inactivos;
  }
  
  // Ejecutar al cargar la página
  document.addEventListener('DOMContentLoaded', function() {
    contarUsuarios();
  });
</script>
</body>
</html>