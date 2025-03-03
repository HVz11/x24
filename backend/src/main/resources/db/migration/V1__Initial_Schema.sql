-- Users and Accounts
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    plan_type VARCHAR(50) NOT NULL,
    daily_limit INT NOT NULL,
    monthly_limit INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    account_id INT NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Templates
CREATE TABLE templates (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    subject TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Recipients
CREATE TABLE recipients (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    properties JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    unsubscribed_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    UNIQUE (account_id, email)
);

-- Lists and List Recipients
CREATE TABLE lists (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

CREATE TABLE list_recipients (
    list_id INT NOT NULL,
    recipient_id INT NOT NULL,
    added_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (list_id, recipient_id),
    FOREIGN KEY (list_id) REFERENCES lists(id),
    FOREIGN KEY (recipient_id) REFERENCES recipients(id)
);

-- Campaigns and Email Jobs
CREATE TABLE campaigns (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    template_id INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    scheduled_at TIMESTAMP WITH TIME ZONE,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (template_id) REFERENCES templates(id)
);

CREATE TABLE email_jobs (
    id SERIAL PRIMARY KEY,
    campaign_id INT NOT NULL,
    recipient_email VARCHAR(255) NOT NULL,
    recipient_name VARCHAR(255),
    metadata JSONB,
    status VARCHAR(20) NOT NULL,
    scheduled_at TIMESTAMP WITH TIME ZONE,
    sent_at TIMESTAMP WITH TIME ZONE,
    opened_at TIMESTAMP WITH TIME ZONE,
    clicked_at TIMESTAMP WITH TIME ZONE,
    delivered_at TIMESTAMP WITH TIME ZONE,
    failed_reason TEXT,
    external_id VARCHAR(255),
    retry_count INT DEFAULT 0,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);

-- Analytics
CREATE TABLE analytics (
    id SERIAL PRIMARY KEY,
    email_job_id INT NOT NULL,
    event_type VARCHAR(20) NOT NULL,
    event_time TIMESTAMP WITH TIME ZONE NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    geo_data JSONB,
    FOREIGN KEY (email_job_id) REFERENCES email_jobs(id)
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_campaigns_account_id ON campaigns(account_id);
CREATE INDEX idx_templates_account_id ON templates(account_id);
CREATE INDEX idx_recipients_account_id ON recipients(account_id);
CREATE INDEX idx_email_jobs_campaign_id ON email_jobs(campaign_id);
CREATE INDEX idx_analytics_email_job_id ON analytics(email_job_id);
CREATE INDEX idx_analytics_event_time ON analytics(event_time);