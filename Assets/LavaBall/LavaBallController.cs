using UnityEngine;
using UnityEngine.InputSystem;

public class LavaBallController : MonoBehaviour
{
    Vector2 moveInput;

    [Header("Rotation")]
    [Range(1f, 50f)]
    public float angularAcceleration = 30.0f;
    [Range(0.01f, 10f)]
    public float angularMaxSpeed = 2.0f;
    [Header("Movement")]
    [Range(1f, 5000f)]
    public float acceleration = 300.0f;
    [Range(0.01f, 100f)]
    public float maxSpeed = 3.0f;

    Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.maxAngularVelocity = angularMaxSpeed;
        
    }

    private void FixedUpdate()
    {

        // Applies Linear and Angular Velocity to Rigid body of player.    
        rb.AddForce(transform.forward * moveInput.y * acceleration * Time.fixedDeltaTime);
        rb.AddTorque(transform.up * moveInput.x * angularAcceleration * Time.fixedDeltaTime);

        if (transform.position.y < 0f)
        {
            float submergedAmount = -transform.position.y;

            Vector3 buoyantForce = new Vector3(0, Mathf.Abs(Physics.gravity.y) * 400.0f * submergedAmount * Time.fixedDeltaTime, 0);
            rb.AddForce(buoyantForce,ForceMode.Acceleration);
            rb.drag = transform.position.y * -15 + .2f;
        }
        else
        {
            rb.drag = .2f;
        }
    }
    public void OnMove(InputAction.CallbackContext context)
    {
        moveInput = context.ReadValue<Vector2>();
        float magnitude2D = Mathf.Sqrt(rb.velocity.x*rb.velocity.x + rb.velocity.z *rb.velocity.z);
        float speedLimiter = Mathf.Min((maxSpeed - magnitude2D) / maxSpeed, maxSpeed);
        moveInput.y *= speedLimiter;

        if (transform.position.y > 1)
        {
            moveInput.y *=.5f;
        }
        
    }

    public void OnJump(InputAction.CallbackContext context)
    {
        if(transform.position.y < 0.1)
        {
            rb.AddForce(transform.up * 120, ForceMode.Force);
        }
        
    }

    public void OnQuit(InputAction.CallbackContext context)
    {
        Application.Quit();

    }
}
