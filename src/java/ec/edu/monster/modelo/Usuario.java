package ec.edu.monster.modelo;

import java.util.Date;

public class Usuario {
    // Corresponde a XEUSU_USUAR
    private int usuIdUsuario;      // XEUSU_ID_USUARIO
    private int xeperId;          // XEPER_ID (persona)
    private String username;      // XEUSU_USERNAME
    private String passwordHash;  // PASSWORDHASH (por ahora texto plano)
    private String emailUsuario;  // EMAIL_USUARIO
    private String estadoCodigo;  // XEEST_CODIGO
    private String pempCodigo;    // PEEMP_CODIGO
    private Date fechaCreacion;   // XEUSU_FECCRE
    private Date fechaModificacion; // XEUSU_FECMOD

    // Datos de persona (JOIN con XEPER_PERSONA)
    private String nombreEmpleado;   // XEPER_NOMBRES
    private String apellidoEmpleado; // XEPER_APELLIDOS
    private String correoEmpleado;   // XEPER_EMAIL
    private String cedula;           // XEPER_CEDULA
    private String sexo;             // XEPER_SEXO
    private String estadoCivil;      // XEPER_ESTADO_CIVIL
    private Date fechaNac;           // XEPER_FECHA_NAC
    private String direccion;        // XEPER_DIRECCION
    private String telefono;         // XEPER_TELEFONO
    private Date fechaRegistro;      // XEPER_FECHA_REGISTRO
    private String email;            // XEPER_EMAIL (alias para correoEmpleado)

    // Datos de empleado (LEFT JOIN PEEMP_EMPLE)
    private String estadoEmpleado;   // PEEMP_ESTADOEMPLEADO
    
    // IDs de estudiante o docente
    private String idEstudiante;     // ID del estudiante (ej: L00418241)
    private String idDocente;        // ID del docente
    private String idAcademico;      // ID académico genérico
    private String tipoUsuario;      // Tipo: "ESTUDIANTE" o "DOCENTE"
    private String fotoPath;         // Ruta de la foto de perfil
    
    // Control de contraseña
    private String primerIngreso;    // 'S'=Primer ingreso, 'N'=No es primer ingreso
    private String contrasenaTempora; // 'S'=Temporal, 'N'=Normal

    public Usuario() { }

    // Getters / Setters
    public int getUsuIdUsuario() {
        return usuIdUsuario;
    }
    public void setUsuIdUsuario(int usuIdUsuario) {
        this.usuIdUsuario = usuIdUsuario;
    }

    public int getXeperId() {
        return xeperId;
    }
    public void setXeperId(int xeperId) {
        this.xeperId = xeperId;
    }

    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmailUsuario() {
        return emailUsuario;
    }
    public void setEmailUsuario(String emailUsuario) {
        this.emailUsuario = emailUsuario;
    }

    public String getEstadoCodigo() {
        return estadoCodigo;
    }
    public void setEstadoCodigo(String estadoCodigo) {
        this.estadoCodigo = estadoCodigo;
    }

    public String getPempCodigo() {
        return pempCodigo;
    }
    public void setPempCodigo(String pempCodigo) {
        this.pempCodigo = pempCodigo;
    }

    public Date getFechaCreacion() {
        return fechaCreacion;
    }
    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public Date getFechaModificacion() {
        return fechaModificacion;
    }
    public void setFechaModificacion(Date fechaModificacion) {
        this.fechaModificacion = fechaModificacion;
    }

    public String getNombreEmpleado() {
        return nombreEmpleado;
    }
    public void setNombreEmpleado(String nombreEmpleado) {
        this.nombreEmpleado = nombreEmpleado;
    }

    public String getApellidoEmpleado() {
        return apellidoEmpleado;
    }
    public void setApellidoEmpleado(String apellidoEmpleado) {
        this.apellidoEmpleado = apellidoEmpleado;
    }

    public String getCorreoEmpleado() {
        return correoEmpleado;
    }
    public void setCorreoEmpleado(String correoEmpleado) {
        this.correoEmpleado = correoEmpleado;
    }

    public String getCedula() {
        return cedula;
    }
    public void setCedula(String cedula) {
        this.cedula = cedula;
    }

    public String getEstadoEmpleado() {
        return estadoEmpleado;
    }
    public void setEstadoEmpleado(String estadoEmpleado) {
        this.estadoEmpleado = estadoEmpleado;
    }

    public String getSexo() {
        return sexo;
    }
    public void setSexo(String sexo) {
        this.sexo = sexo;
    }

    public String getEstadoCivil() {
        return estadoCivil;
    }
    public void setEstadoCivil(String estadoCivil) {
        this.estadoCivil = estadoCivil;
    }

    public Date getFechaNac() {
        return fechaNac;
    }
    public void setFechaNac(Date fechaNac) {
        this.fechaNac = fechaNac;
    }

    public String getDireccion() {
        return direccion;
    }
    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }
    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getIdEstudiante() {
        return idEstudiante;
    }
    public void setIdEstudiante(String idEstudiante) {
        this.idEstudiante = idEstudiante;
    }

    public String getIdDocente() {
        return idDocente;
    }
    public void setIdDocente(String idDocente) {
        this.idDocente = idDocente;
    }

    public String getFotoPath() {
        return fotoPath;
    }
    public void setFotoPath(String fotoPath) {
        this.fotoPath = fotoPath;
    }

    public String getTipoUsuario() {
        return tipoUsuario;
    }
    public void setTipoUsuario(String tipoUsuario) {
        this.tipoUsuario = tipoUsuario;
    }

    // Método solicitado por tu servlet
    public String getNombreCompleto() {
        String n = (nombreEmpleado != null ? nombreEmpleado : "");
        String a = (apellidoEmpleado != null ? apellidoEmpleado : "");
        return (n + " " + a).trim();
    }
    
    // Método para obtener el ID académico preferente (campo genérico) con fallback a estudiante/docente
    public String getIdAcademico() {
        if (idAcademico != null && !idAcademico.isEmpty()) {
            return idAcademico;
        }
        if (idEstudiante != null && !idEstudiante.isEmpty()) {
            return idEstudiante;
        }
        if (idDocente != null && !idDocente.isEmpty()) {
            return idDocente;
        }
        return "N/A";
    }

    public void setIdAcademico(String idAcademico) {
        this.idAcademico = idAcademico;
    }

    public String getPrimerIngreso() {
        return primerIngreso;
    }
    public void setPrimerIngreso(String primerIngreso) {
        this.primerIngreso = primerIngreso;
    }

    public String getContrasenaTempora() {
        return contrasenaTempora;
    }
    public void setContrasenaTempora(String contrasenaTempora) {
        this.contrasenaTempora = contrasenaTempora;
    }

    @Override
    public String toString() {
        return "Usuario{" +
                "usuIdUsuario=" + usuIdUsuario +
                ", username='" + username + '\'' +
                ", nombreCompleto='" + getNombreCompleto() + '\'' +
                ", emailUsuario='" + emailUsuario + '\'' +
                ", estadoCodigo='" + estadoCodigo + '\'' +
                '}';
    }
}
