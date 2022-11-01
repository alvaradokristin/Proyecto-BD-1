using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    //Model with the columns from the ContactoCliente table
    public class Contact
    {
        [Key]
        [Required]
        [StringLength(10)]
        [Display(Name = "Codigo del Cliente")]
        public string? CodigoCliente { get; set; }

        [Key]
        [Required]
        [StringLength(15)]
        public string? Motivo { get; set; }

        [Required]
        [StringLength(12)]
        [Display(Name = "Nombre del Contacto")]
        public string? NombreContacto { get; set; }

        [Required]
        [StringLength(20)]
        public string? Correo { get; set; }

        [Required]
        [StringLength(10)]
        public string? Telefono { get; set; }

        [Required]
        [StringLength(35)]
        public string? Direccion { get; set; }

        [Required]
        [StringLength(30)]
        public string? Descripcion { get; set; }

        [Required]
        [StringLength(12)]
        public string? Sector { get; set; }

        [Required]
        [StringLength(12)]
        public string? Estado { get; set; }

        [Required]
        [StringLength(12)]
        public string? Zona { get; set; }

        [Required]
        [StringLength(12)]
        public string? Tipo { get; set; }

        [Required]
        [StringLength(10)]
        public string? Asesor { get; set; }
    }
}
