package entidad;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Campana {
    
    private int idCampana;
    private String titulo;
    private String descripcion;
    private Date fecha;
    private Time horaInicio;
    private Time horaFin;
    private String lugar;
    private int cuposTotal;
    private int cuposDisponibles;
    private String requisitos;
    private String estado; // PUBLICADA, CERRADA, CANCELADA
    private int idCoordinador;
    private Timestamp fechaCreacion;
    
    // Constructor vacío
    public Campana() {
    }
    
    // Constructor para crear nueva campaña (sin ID)
    public Campana(String titulo, String descripcion, Date fecha, Time horaInicio, 
                   Time horaFin, String lugar, int cuposTotal, String requisitos, 
                   int idCoordinador) {
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.fecha = fecha;
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
        this.lugar = lugar;
        this.cuposTotal = cuposTotal;
        this.cuposDisponibles = cuposTotal; // Inicialmente todos los cupos están disponibles
        this.requisitos = requisitos;
        this.estado = "PUBLICADA"; // Estado por defecto
        this.idCoordinador = idCoordinador;
    }
    
    // Constructor completo
    public Campana(int idCampana, String titulo, String descripcion, Date fecha, 
                   Time horaInicio, Time horaFin, String lugar, int cuposTotal, 
                   int cuposDisponibles, String requisitos, String estado, 
                   int idCoordinador, Timestamp fechaCreacion) {
        this.idCampana = idCampana;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.fecha = fecha;
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
        this.lugar = lugar;
        this.cuposTotal = cuposTotal;
        this.cuposDisponibles = cuposDisponibles;
        this.requisitos = requisitos;
        this.estado = estado;
        this.idCoordinador = idCoordinador;
        this.fechaCreacion = fechaCreacion;
    }
    
    // Getters y Setters
    public int getIdCampana() {
        return idCampana;
    }
    
    public void setIdCampana(int idCampana) {
        this.idCampana = idCampana;
    }
    
    public String getTitulo() {
        return titulo;
    }
    
    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    
    public Date getFecha() {
        return fecha;
    }
    
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
    
    public Time getHoraInicio() {
        return horaInicio;
    }
    
    public void setHoraInicio(Time horaInicio) {
        this.horaInicio = horaInicio;
    }
    
    public Time getHoraFin() {
        return horaFin;
    }
    
    public void setHoraFin(Time horaFin) {
        this.horaFin = horaFin;
    }
    
    public String getLugar() {
        return lugar;
    }
    
    public void setLugar(String lugar) {
        this.lugar = lugar;
    }
    
    public int getCuposTotal() {
        return cuposTotal;
    }
    
    public void setCuposTotal(int cuposTotal) {
        this.cuposTotal = cuposTotal;
    }
    
    public int getCuposDisponibles() {
        return cuposDisponibles;
    }
    
    public void setCuposDisponibles(int cuposDisponibles) {
        this.cuposDisponibles = cuposDisponibles;
    }
    
    public String getRequisitos() {
        return requisitos;
    }
    
    public void setRequisitos(String requisitos) {
        this.requisitos = requisitos;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public int getIdCoordinador() {
        return idCoordinador;
    }
    
    public void setIdCoordinador(int idCoordinador) {
        this.idCoordinador = idCoordinador;
    }
    
    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }
    
    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }
    
    // Métodos auxiliares
    public int getCuposOcupados() {
        return cuposTotal - cuposDisponibles;
    }
    
    public boolean tieneDisponibilidad() {
        return cuposDisponibles > 0;
    }
    
    public double getPorcentajeOcupacion() {
        if (cuposTotal == 0) return 0;
        return ((double) getCuposOcupados() / cuposTotal) * 100;
    }
    
    @Override
    public String toString() {
        return "Campana{" +
                "idCampana=" + idCampana +
                ", titulo='" + titulo + '\'' +
                ", fecha=" + fecha +
                ", lugar='" + lugar + '\'' +
                ", cuposTotal=" + cuposTotal +
                ", cuposDisponibles=" + cuposDisponibles +
                ", estado='" + estado + '\'' +
                '}';
    }
}