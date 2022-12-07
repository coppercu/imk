struct skinio_tasker_swim {
    imk_uint32_t active_nest;   /* 活跃嵌套计数，0表示不活跃 */
    imk_uint32_t *trace_node;    /* 任务 */
};
struct skinio_worker_firm;
struct skinio_tasker_firm {
    const char *name;
    struct skinio_tasker_swim swim;
    const struct skinio_worker_firm *worker;
    skinio_tasker_method_t method;
    void *method_para;
};
typdef const struct skinio_tasker_firm *skinio_tasker_firm_p;

struct skinio_tasker_term {
    const struct skinio_tasker_firm *head;
    const struct skinio_tasker_firm *tail;
};

struct skinio_tasker_bale;
struct skinio_tasker_bale_node {
    imk_list_t node;
    const struct skinio_tasker_bale *bale;
};

struct skinio_tasker_bale {
    const char *name;
    ims_uint32_t *nest;
    struct skinio_tasker_bale_node *node;
    const struct skinio_tasker_firm **head;
    const struct skinio_tasker_firm **tail;
};

struct skinio_worker_swim {

}

struct skinio_worker_firm {

}
