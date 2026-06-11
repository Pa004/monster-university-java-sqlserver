<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
  <title>${accion == 'crear' ? 'Nuevo' : 'Editar'} Usuario | Monster U</title>
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="bower_components/font-awesome/css/font-awesome.min.css">
  <link rel="stylesheet" href="dist/css/AdminLTE.min.css">
  <link rel="stylesheet" href="dist/css/skins/_all-skins.min.css">
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
              <img src="dist/img/user2-160x160.jpg" class="user-image" alt="User Image">
              <span class="hidden-xs">${sessionScope.nombreCompleto}</span>
            </a>
            <ul class="dropdown-menu">
              <li class="user-header">
                <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
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
      <div class="user-panel">
        <div class="pull-left image">
          <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
        </div>
        <div class="pull-left info">
          <p>${sessionScope.nombreCompleto}</p>
          <a href="#"><i class="fa fa-circle text-success"></i> En línea</a>
        </div>
      </div>
      <ul class="sidebar-menu" data-widget="tree">
        <li class="header">MENÚ PRINCIPAL</li>
        <li><a href="index.jsp"><i class="fa fa-dashboard"></i> <span>Dashboard</span></a></li>
        <li class="active"><a href="srvUsuario?accion=listar"><i class="fa fa-users"></i> <span>Gestión de Usuarios</span></a></li>
        <li><a href="srvUsuario?accion=logout"><i class="fa fa-sign-out"></i> <span>Cerrar Sesión</span></a></li>
      </ul>
    </section>
  </aside>

  <!-- Content -->
  <div class="content-wrapper">
    <section class="content-header">
      <h1>
        ${accion == 'crear' ? 'Nuevo Usuario' : 'Editar Usuario'}
        <small>Complete el formulario</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="index.jsp"><i class="fa fa-dashboard"></i> Inicio</a></li>
        <li><a href="srvUsuario?accion=listar">Usuarios</a></li>
        <li class="active">${accion == 'crear' ? 'Nuevo' : 'Editar'}</li>
      </ol>
    </section>

    <section class="content">
      
      <!-- Mensajes de error -->
      <c:if test="${not empty mensaje}">
        <div class="alert alert-${tipoMensaje == 'success' ? 'success' : 'danger'} alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <i class="icon fa fa-${tipoMensaje == 'success' ? 'check' : 'ban'}"></i> ${mensaje}
        </div>
      </c:if>

      <form action="srvUsuario" method="POST" id="formUsuario" enctype="multipart/form-data">
        <input type="hidden" name="accion" value="${accion}">
        <c:if test="${accion == 'actualizar'}">
          <input type="hidden" name="idUsuario" value="${usuario.usuIdUsuario}">
        </c:if>

        <!-- Navegación por secciones -->
        <div class="nav-tabs-custom">
          <ul class="nav nav-tabs">
            <li class="active"><a href="#tab-personal" data-toggle="tab"><i class="fa fa-id-card"></i> Información Personal</a></li>
            <li><a href="#tab-perfiles" data-toggle="tab"><i class="fa fa-shield"></i> Perfiles y Permisos</a></li>
            <li><a href="#tab-foto" data-toggle="tab"><i class="fa fa-camera"></i> Foto de Perfil</a></li>
            <li><a href="#tab-cuenta" data-toggle="tab"><i class="fa fa-key"></i> Cuenta de Usuario</a></li>
          </ul>
          <div class="tab-content" style="padding-top: 15px;">
            <!-- 1. Datos Personales -->
            <!-- 1. Información Personal -->
            <div class="tab-pane active" id="tab-personal">
              <div class="box box-primary">
                <div class="box-header with-border">
                  <h3 class="box-title"><i class="fa fa-user"></i> Datos Personales</h3>
                </div>
                <div class="box-body">
                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Cédula <span class="text-danger">*</span></label>
                        <input type="text" name="cedula" class="form-control" 
                               value="${persona.cedula}" 
                               required maxlength="10" pattern="[0-9]{10}"
                               placeholder="Ej: 1234567890">
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Email Personal <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control" 
                               value="${persona.email}" 
                               required placeholder="Ej: persona@email.com">
                      </div>
                    </div>
                  </div>
                  
                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Nombres <span class="text-danger">*</span></label>
                        <input type="text" name="nombres" class="form-control" 
                               value="${persona.nombres}" 
                               required maxlength="128" placeholder="Nombres completos">
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Apellidos <span class="text-danger">*</span></label>
                        <input type="text" name="apellidos" class="form-control" 
                               value="${persona.apellidos}" 
                               required maxlength="128" placeholder="Apellidos completos">
                      </div>
                    </div>
                  </div>

                  <c:if test="${accion == 'crear'}">
                    <div class="row">
                      <div class="col-md-4">
                        <div class="form-group">
                          <label>Fecha de Nacimiento <span class="text-danger">*</span></label>
                          <input type="date" name="fechaNac" class="form-control" required>
                        </div>
                      </div>
                      <div class="col-md-4">
                        <div class="form-group">
                          <label>Sexo <span class="text-danger">*</span></label>
                          <select name="sexo" class="form-control" required>
                            <option value="">Seleccione...</option>
                            <option value="M">Masculino</option>
                            <option value="F">Femenino</option>
                          </select>
                        </div>
                      </div>
                      <div class="col-md-4">
                        <div class="form-group">
                          <label>Estado Civil <span class="text-danger">*</span></label>
                          <select name="estadoCivil" class="form-control" required>
                            <option value="">Seleccione...</option>
                            <option value="S">Soltero/a</option>
                            <option value="C">Casado/a</option>
                            <option value="D">Divorciado/a</option>
                            <option value="V">Viudo/a</option>
                            <option value="U">Unión Libre</option>
                          </select>
                        </div>
                      </div>
                    </div>

                    <div class="row">
                      <div class="col-md-8">
                        <div class="form-group">
                          <label>Dirección</label>
                          <input type="text" name="direccion" class="form-control" maxlength="264" 
                                 placeholder="Dirección domiciliaria">
                        </div>
                      </div>
                      <div class="col-md-4">
                        <div class="form-group">
                          <label>Teléfono</label>
                          <input type="text" name="telefono" class="form-control" maxlength="10" 
                                 pattern="[0-9]{10}" placeholder="0987654321">
                        </div>
                      </div>
                    </div>

                    <!-- Información -->
                    <div class="alert alert-info" style="border-left: 4px solid #3c8dbc;">
                      <p style="margin: 0;"><i class="fa fa-info-circle"></i> <strong>Nota:</strong> Complete la información personal del usuario. Los campos marcados con <span class="text-red">*</span> son obligatorios.</p>
                    </div>
                  </c:if>
                </div>
              </div>
              <!-- Botones de navegación -->
              <div class="box-footer text-right">
                <button type="button" class="btn btn-primary btn-lg btn-next" data-next="tab-perfiles">
                  Siguiente <i class="fa fa-arrow-right"></i>
                </button>
              </div>
            </div>

            <!-- 2. Perfiles y Permisos -->
            <div class="tab-pane" id="tab-perfiles">
              <div class="box" style="border-top: 3px solid #f39c12; box-shadow: 0 4px 12px rgba(0,0,0,0.08);">
                <div class="box-header with-border" style="background: linear-gradient(135deg, #ffffff 0%, #fff8f0 100%);">
                  <h3 class="box-title" style="color: #f39c12; font-weight: 700;">
                    <i class="fa fa-shield"></i> Perfiles y Permisos
                  </h3>
                </div>
                <div class="box-body" style="padding: 25px;">
                  <div class="alert" style="background: linear-gradient(135deg, #e3f2fd 0%, #f0f8ff 100%); border-left: 4px solid #3c8dbc; border-radius: 6px; margin-bottom: 25px;">
                    <i class="fa fa-info-circle" style="font-size: 18px; color: #3c8dbc;"></i> 
                    <strong style="color: #2c6fa3;">Instrucciones:</strong> 
                    <span style="color: #555;">Seleccione los perfiles que tendrá este usuario. El perfil de <strong>Estudiante</strong> es exclusivo.</span>
                  </div>

                  <div class="row">
                    <c:forEach items="${perfiles}" var="perfil">
                      <div class="col-md-6 col-sm-12" style="margin-bottom: 15px;">
                        <div class="perfil-card" style="background: #fff; border: 2px solid #e0e0e0; border-radius: 10px; padding: 18px; transition: all 0.3s ease; cursor: pointer; position: relative;">
                          <label style="cursor: pointer; width: 100%; margin: 0; display: flex; align-items: center;">
                            <input type="checkbox" name="perfiles" value="${perfil.codigo}" 
                                   data-descripcion="${perfil.descripcion}"
                                   data-codigo="${perfil.codigo}"
                                   class="perfil-checkbox"
                                   style="width: 22px; height: 22px; margin-right: 15px; cursor: pointer;"
                                   <c:if test="${accion == 'actualizar'}">
                                     <c:forEach items="${perfilesActivos}" var="perfilActivo">
                                       ${perfilActivo == perfil.codigo ? 'checked' : ''}
                                     </c:forEach>
                                   </c:if>>
                            <div style="flex: 1;">
                              <h4 style="margin: 0 0 8px 0; font-size: 16px; font-weight: 700; color: #3c8dbc;">
                                <i class="fa fa-user-shield"></i> ${perfil.descripcion}
                              </h4>
                              <c:if test="${not empty perfil.observacion}">
                                <p style="margin: 0; font-size: 13px; color: #666; line-height: 1.5;">${perfil.observacion}</p>
                              </c:if>
                            </div>
                          </label>
                        </div>
                      </div>
                    </c:forEach>
                  </div>
                </div>
              </div>
              <!-- Botones de navegación -->
              <div class="box-footer">
                <button type="button" class="btn btn-default btn-lg btn-prev" data-prev="tab-personal">
                  <i class="fa fa-arrow-left"></i> Anterior
                </button>
                <button type="button" class="btn btn-primary btn-lg btn-next pull-right" data-next="tab-foto">
                  Siguiente <i class="fa fa-arrow-right"></i>
                </button>
              </div>
            </div>

            <!-- 3. Foto de Perfil -->
            <div class="tab-pane" id="tab-foto">
              <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title"><i class="fa fa-camera"></i> Foto de Perfil</h3>
                </div>
                <div class="box-body">
                  <div class="alert alert-info" style="border-left: 4px solid #00c0ef;">
                    <i class="fa fa-info-circle"></i> Sube una imagen cuadrada (ej. 400x400). Peso máximo recomendado 2 MB.
                  </div>
                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Seleccionar foto</label>
                        <input type="file" name="fotoPerfil" id="fotoPerfil" class="form-control" accept="image/*">
                        <small class="text-muted">Formatos permitidos: JPG, PNG, WEBP.</small>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Previsualización</label>
                        <div id="previewWrapper" style="border: 1px dashed #00c0ef; border-radius: 8px; padding: 10px; text-align: center; min-height: 180px; display: flex; align-items: center; justify-content: center; background: #f7fdff;">
                          <span id="previewPlaceholder" style="color: #7a7a7a;">Aún no se ha cargado una imagen</span>
                          <img id="fotoPreview" src="" alt="Previsualización" style="max-width: 160px; max-height: 160px; border-radius: 8px; display: none;" />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- Botones de navegación -->
              <div class="box-footer">
                <button type="button" class="btn btn-default btn-lg btn-prev" data-prev="tab-perfiles">
                  <i class="fa fa-arrow-left"></i> Anterior
                </button>
                <button type="button" class="btn btn-primary btn-lg btn-next pull-right" data-next="tab-cuenta">
                  Siguiente <i class="fa fa-arrow-right"></i>
                </button>
              </div>
            </div>

            <!-- 4. Cuenta de Usuario -->
            <div class="tab-pane" id="tab-cuenta">
              <div class="box box-success">
                <div class="box-header with-border">
                  <h3 class="box-title"><i class="fa fa-key"></i> Datos de Acceso al Sistema</h3>
                </div>
                <div class="box-body">
                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Nombre de Usuario <span class="text-danger">*</span></label>
                        <input type="text" name="username" class="form-control" 
                               value="${usuario.username}" 
                               required maxlength="32" 
                               pattern="[a-zA-Z0-9_]+"
                               placeholder="Solo letras, números y guión bajo">
                        <small class="text-muted">Este será el usuario para iniciar sesión</small>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>
                          Contraseña 
                          <span class="text-danger">*</span>
                          <c:if test="${accion == 'actualizar'}">
                            <small class="text-muted">(Dejar en blanco para no cambiar)</small>
                          </c:if>
                        </label>
                        <input type="password" name="password" class="form-control" 
                               ${accion == 'crear' ? 'required' : ''} 
                               minlength="6" maxlength="50"
                               placeholder="Mínimo 6 caracteres">
                      </div>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label>Email de Usuario <span class="text-danger">*</span></label>
                        <input type="email" name="emailUsuario" class="form-control" 
                               value="${usuario.emailUsuario}" 
                               required maxlength="128"
                               placeholder="correo@monsteru.edu.ec">
                        <small class="text-muted">Email institucional para notificaciones</small>
                      </div>
                    </div>
                  </div>

                  <c:if test="${accion == 'actualizar'}">
                    <div class="row">
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Estado <span class="text-danger">*</span></label>
                          <select name="estado" class="form-control" required>
                            <option value="A" ${usuario.estadoCodigo == 'A' ? 'selected' : ''}>Activo</option>
                            <option value="I" ${usuario.estadoCodigo == 'I' ? 'selected' : ''}>Inactivo</option>
                          </select>
                        </div>
                      </div>
                    </div>
                  </c:if>
                </div>
              </div>
              <!-- Botones de navegación -->
              <div class="box-footer">
                <button type="button" class="btn btn-default btn-lg btn-prev" data-prev="tab-foto">
                  <i class="fa fa-arrow-left"></i> Anterior
                </button>
                <div class="pull-right">
                  <button type="submit" class="btn btn-success btn-lg">
                    <i class="fa fa-save"></i> ${accion == 'crear' ? 'Crear Usuario' : 'Actualizar Usuario'}
                  </button>
                  <a href="srvUsuario?accion=listar" class="btn btn-default btn-lg">
                    <i class="fa fa-times"></i> Cancelar
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </form>

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
<style>
  /* Efectos hover para tarjetas de perfil */
  .perfil-card:hover {
    border-color: #3c8dbc !important;
    box-shadow: 0 4px 16px rgba(60, 141, 188, 0.25) !important;
    transform: translateY(-2px);
  }
  
  .perfil-card input[type="checkbox"]:checked + div h4 {
    color: #00a65a !important;
  }
  
  .perfil-card input[type="checkbox"]:checked ~ .perfil-card,
  .perfil-card:has(input[type="checkbox"]:checked) {
    border-color: #00a65a !important;
    background: linear-gradient(135deg, #f0fff4 0%, #ffffff 100%) !important;
  }
</style>
<script>
  // Validación del formulario + lógica de perfiles exclusivos
  document.getElementById('formUsuario').addEventListener('submit', function(e) {
    var perfiles = document.querySelectorAll('input[name="perfiles"]:checked');
    if (perfiles.length === 0) {
      e.preventDefault();
      alert('Debe seleccionar al menos un perfil para el usuario');
      return false;
    }
  });
  
  // Lógica de perfiles: Estudiante es exclusivo
  (function() {
    var checkboxes = document.querySelectorAll('.perfil-checkbox');
    
    function esEstudiante(checkbox) {
      var desc = (checkbox.dataset.descripcion || '').toUpperCase();
      var cod = (checkbox.dataset.codigo || '').toUpperCase();
      return desc.indexOf('ESTUD') !== -1 || cod.indexOf('ESTUD') !== -1;
    }
    
    function validarSeleccion() {
      var marcados = Array.from(document.querySelectorAll('.perfil-checkbox:checked'));
      var estudianteMarcado = marcados.some(esEstudiante);
      
      // Si está marcado Estudiante, deshabilitar los demás
      checkboxes.forEach(function(cb) {
        if (estudianteMarcado && !esEstudiante(cb)) {
          cb.disabled = true;
          cb.checked = false;
          cb.parentElement.style.opacity = '0.5';
        } else if (!estudianteMarcado) {
          cb.disabled = false;
          cb.parentElement.style.opacity = '1';
        }
      });
      
      // Si se marca otro perfil, deshabilitar Estudiante
      var otrosMarcados = marcados.some(function(cb) { return !esEstudiante(cb); });
      checkboxes.forEach(function(cb) {
        if (otrosMarcados && esEstudiante(cb)) {
          cb.disabled = true;
          cb.checked = false;
          cb.parentElement.style.opacity = '0.5';
        }
      });
    }
    
    checkboxes.forEach(function(cb) {
      cb.addEventListener('change', validarSeleccion);
    });
    
    // Validar estado inicial
    validarSeleccion();
  })();

  // Previsualización de foto de perfil
  (function() {
    var input = document.getElementById('fotoPerfil');
    var preview = document.getElementById('fotoPreview');
    var placeholder = document.getElementById('previewPlaceholder');
    if (!input || !preview) return;

    input.addEventListener('change', function() {
      if (!this.files || this.files.length === 0) {
        preview.style.display = 'none';
        if (placeholder) placeholder.style.display = 'inline';
        return;
      }

      var file = this.files[0];
      if (!file.type.startsWith('image/')) {
        alert('El archivo debe ser una imagen (JPG, PNG, WEBP)');
        this.value = '';
        preview.style.display = 'none';
        if (placeholder) placeholder.style.display = 'inline';
        return;
      }

      if (file.size > 2 * 1024 * 1024) { // 2 MB
        alert('La imagen no debe superar los 2 MB');
        this.value = '';
        preview.style.display = 'none';
        if (placeholder) placeholder.style.display = 'inline';
        return;
      }

      var url = URL.createObjectURL(file);
      preview.src = url;
      preview.style.display = 'inline-block';
      if (placeholder) placeholder.style.display = 'none';
    });
  })();

  // Navegación entre pestañas con botones
  (function(){
    var btnNext = document.querySelectorAll('.btn-next');
    var btnPrev = document.querySelectorAll('.btn-prev');
    
    // Botones "Siguiente"
    btnNext.forEach(function(btn) {
      btn.addEventListener('click', function() {
        var nextTab = this.getAttribute('data-next');
        $('a[href="#' + nextTab + '"]').tab('show');
        window.scrollTo(0, 0);
      });
    });
    
    // Botones "Anterior"
    btnPrev.forEach(function(btn) {
      btn.addEventListener('click', function() {
        var prevTab = this.getAttribute('data-prev');
        $('a[href="#' + prevTab + '"]').tab('show');
        window.scrollTo(0, 0);
      });
    });
  })();
</script>
</body>
</html>