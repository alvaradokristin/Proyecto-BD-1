using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    public class Zone
    {
        [Key]
        [Required]
        [StringLength(12)]
        public string? nombre { get; set; }
    }
}
