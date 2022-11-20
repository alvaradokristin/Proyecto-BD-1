using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    public class User
    {
        [Key]
        [Required]
        [StringLength(12)]
        public string? userLogin { get; set; }

        [Required]
        [StringLength(10)]
        public string? cedula { get; set; }

        [Required]
        [StringLength(12)]
        public string? nombre { get; set; }

        [Required]
        [StringLength(12)]
        public string? primerApellido { get; set; }

        [Required]
        [StringLength(12)]
        public string? segundoApellido { get; set; }

        [Required]
        [StringLength(13)]
        public string? clave { get; set; }

        [Required]
        [StringLength(12)]
        public string? nombre_rol { get; set; }

        [Required]
        [StringLength(10)]
        public string? codigo_departamento { get; set; }

        public string? nombreCompleto
        {
            get
            {
                return nombre + " " + primerApellido + " " + segundoApellido;
            }
        }

        public double? monto { get; set; }
        public int? cantidad { get; set; }
    }
}
