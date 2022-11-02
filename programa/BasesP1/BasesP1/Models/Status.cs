using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    public class Status
    {
        [Key]
        [Required]
        [StringLength(10)]
        public string? Categoria { get; set; }

        [Key]
        [Required]
        [StringLength(12)]
        public string? Nombre { get; set; }
    }
}
