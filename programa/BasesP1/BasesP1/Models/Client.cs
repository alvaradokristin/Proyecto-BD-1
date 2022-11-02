using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    public class Client
    {
        [Key]
        [Required]
        [StringLength(10)]
        public string? codigo { get; set; }

        [Required]
        [StringLength(12)]
        public string? nombreCuenta { get; set; }

        [Required]
        [StringLength(20)]
        public string? correo { get; set; }

        [Required]
        [StringLength(10)]
        public string? telefono { get; set; }

        [Required]
        [StringLength(10)]
        public string? celular { get; set; }

        [Required]
        [StringLength(22)]
        public string? sitioWeb { get; set; }

        [Required]
        [StringLength(30)]
        public string? informacionAdicional { get; set; }

        [Required]
        [StringLength(12)]
        public string? zona { get; set; }

        [Required]
        [StringLength(12)]
        public string? sector { get; set; }

        [Required]
        [StringLength(4)]
        public string? abreviatura_moneda { get; set; }

        [Required]
        [StringLength(12)]
        public string? nombre_moneda { get; set; }

        [Required]
        [StringLength(10)]
        public string? login_usuario { get; set; }

        public Int16? numeroCotizacion { get; set; }
    }
}
