namespace BasesP1.Models
{
    public class Execution
    {
        public string? Codigo { get; set; }
        public string? Nombre { get; set; }
        public string? Fecha { get; set; }
        public string? CodigoProyecto { get; set; }
        public string? CodigoDepartamento { get; set; }
        public string? Asesor { get; set; } //Login
        public int? Cantidad { get; set; }
        public double? Monto { get; set; }
    }
}
