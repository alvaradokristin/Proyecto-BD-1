namespace BasesP1.Models
{
    public class TasksByUser
    {
        public string? Login { get; set; }
        public string? Nombre { get; set; }
        public string? PrimerApellido { get; set; }
        public string? SegundoApellido { get; set; }
        public int? Iniciadas { get; set; }
        public int? EnProgreso { get; set; }
        public int? Finalizadas { get; set; }
        public int? Total { get; set; }
        public string? NombreCompleto
        {
            get
            {
                return Nombre + " " + PrimerApellido + " " + SegundoApellido;
            }
        }
    }
}
