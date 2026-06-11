package ec.edu.monster.modelo;

import java.util.Date;

public class Persona {
    private int id;
    private String estadoCivilCodigo; // PEESC_CODIGO
    private String sexoCodigo;        // PESEX_CODIGO
    private String cedula;
    private String nombres;
    private String apellidos;
    private Date fechaNac;
    private String direccion;
    private String telefono;
    private String email;
    private Date fechaRegistro;
    private String tipoPersona;

    public Persona() { }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEstadoCivilCodigo() {
        return estadoCivilCodigo;
    }

    public void setEstadoCivilCodigo(String estadoCivilCodigo) {
        this.estadoCivilCodigo = estadoCivilCodigo;
    }

    public String getSexoCodigo() {
        return sexoCodigo;
    }

    public void setSexoCodigo(String sexoCodigo) {
        this.sexoCodigo = sexoCodigo;
    }

    public String getCedula() {
        return cedula;
    }

    public void setCedula(String cedula) {
        this.cedula = cedula;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getTipoPersona() {
        return tipoPersona;
    }

    public void setTipoPersona(String tipoPersona) {
        this.tipoPersona = tipoPersona;
    }


}
